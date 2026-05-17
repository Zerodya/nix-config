{ config, pkgs, ... }:

let
  music-dir = "/mnt/storage/music";
  beets-home = "/var/lib/beets";

  # Languages to translate in ISO 639-1 codes.
  target-langs = [
    "ja" # japanese 
    "zh" # chinese
    "ko" # korean
  ];

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    requests
    mutagen
    langdetect
  ]);

  translateLyricsPy = pkgs.writeTextFile {
    name = "translate-lyrics.py";
    text = ''
      import os
      import sys
      import json
      import argparse
      import requests
      from mutagen.flac import FLAC
      from langdetect import detect, LangDetectException
      from datetime import datetime
      
      MUSIC_DIR = "${music-dir}"
      DEEPL_AUTH_KEY = os.environ.get("DEEPL_AUTH_KEY", "").strip()
      if not DEEPL_AUTH_KEY:
          print("lyrics: DEEPL_AUTH_KEY is not set or empty", file=sys.stderr)
          sys.exit(1)
      
      TARGET_LANG = "EN"
      DEEPL_API_URL = "https://api-free.deepl.com/v2/translate"
      STORE_FILE = "${beets-home}/translations_store.json"
      
      # Baked in at build time from your Nix list
      TARGET_LANGS = ${builtins.toJSON target-langs}
      # Also accept a fast lookup set
      TARGET_LANGS_SET = set(TARGET_LANGS)
      
      def load_store():
          if os.path.exists(STORE_FILE):
              with open(STORE_FILE, "r") as f:
                  try:
                      return json.load(f)
                  except json.JSONDecodeError:
                      return {}
          return {}
      
      def save_store(store):
          print("lyrics: writing store to %s (%d entries)" % (STORE_FILE, len(store)))
          sys.stdout.flush()
          with open(STORE_FILE, "w") as f:
              json.dump(store, f, indent=4)
          sys.stdout.flush()
      
      def translate_text(text, target_lang=TARGET_LANG):
          headers = {
              "Authorization": "DeepL-Auth-Key " + DEEPL_AUTH_KEY,
              "Content-Type": "application/x-www-form-urlencoded",
          }
          payload = {
              'text': text,
              'target_lang': target_lang,
          }
          try:
              response = requests.post(DEEPL_API_URL, headers=headers, data=payload, timeout=30)
          except requests.exceptions.RequestException as e:
              print("lyrics: network error contacting deepl: %s" % e)
              return None
          
          if response.status_code == 200:
              try:
                  return response.json()['translations'][0]['text']
              except (KeyError, IndexError, json.JSONDecodeError) as e:
                  print("lyrics: malformed deepl 200 response: %s | body: %s" % (e, response.text[:500]))
                  return None
          else:
              print("lyrics: deepl api error %d for text starting with: %s..." % (response.status_code, text[:30]))
              print("lyrics: deepl response body: %s" % response.text[:500])
              return None
      
      def process_flac_file(file_path, dry_run=False, force=False, store=None):
          abs_path = os.path.abspath(file_path)
          try:
              audio = FLAC(file_path)
          except Exception as e:
              print("lyrics: error opening file %s: %s" % (file_path, e))
              return
      
          if "LYRICS" in audio:
              original_lyrics = audio["LYRICS"][0]
              try:
                  detected_lang = detect(original_lyrics)
              except LangDetectException as e:
                  print("lyrics: could not detect language %s: %s" % (file_path, e))
                  store[abs_path] = {"status": "detection_failed", "timestamp": datetime.now().isoformat()}
                  return
              except Exception as e:
                  print("lyrics: unexpected langdetect error %s: %s" % (file_path, e))
                  store[abs_path] = {"status": "detection_failed", "timestamp": datetime.now().isoformat()}
                  return
              
              lang_lower = detected_lang.lower()
              
              if lang_lower in TARGET_LANGS_SET:
                  print("lyrics: translating file (detected %s, in target list): %s" % (lang_lower, file_path))
                  translated = translate_text(original_lyrics)
                  if translated:
                      if dry_run:
                          print("lyrics: dry run translation preview: %s" % file_path)
                          print("lyrics: %s: %s" % (translated.lower(), file_path))
                      else:
                          audio["LYRICS"] = [translated]
                          try:
                              audio.save()
                              print("lyrics: updated with translated lyrics: %s" % file_path)
                          except Exception as e:
                              print("lyrics: error saving file %s: %s" % (file_path, e))
                              store[abs_path] = {"status": "save_error", "timestamp": datetime.now().isoformat()}
                              return
                      store[abs_path] = {"status": "translated", "timestamp": datetime.now().isoformat()}
                  else:
                      print("lyrics: translation failed for: %s" % file_path)
                      store[abs_path] = {"status": "translation_failed", "timestamp": datetime.now().isoformat()}
              elif lang_lower == "en":
                  print("lyrics: lyrics already in english: %s" % file_path)
                  store[abs_path] = {"status": "english", "timestamp": datetime.now().isoformat()}
              else:
                  # Not English and not in the target list — skip forever
                  print("lyrics: skipping file (detected %s, not in target list %s): %s" % (lang_lower, TARGET_LANGS, file_path))
                  store[abs_path] = {"status": "skipped", "reason": "language_not_in_target_list", "detected_lang": lang_lower, "timestamp": datetime.now().isoformat()}
          else:
              print("lyrics: no lyrics tag found: %s" % file_path)
              store[abs_path] = {"status": "no_lyrics", "timestamp": datetime.now().isoformat()}
      
      def iterate_albums(directory, dry_run=False, force=False):
          store = load_store() if not force else {}
          skipped_count = 0
          processed_count = 0
      
          try:
              for root, dirs, files in os.walk(directory):
                  for file in files:
                      if not file.lower().endswith(".flac"):
                          continue
                      file_path = os.path.join(root, file)
                      abs_path = os.path.abspath(file_path)
                      if not force and abs_path in store:
                          skipped_count += 1
                          continue
                      
                      try:
                          process_flac_file(file_path, dry_run=dry_run, force=force, store=store)
                          processed_count += 1
                      except Exception as e:
                          print("lyrics: UNEXPECTED ERROR on %s: %s" % (file_path, e))
                          import traceback
                          traceback.print_exc()
                          store[abs_path] = {"status": "crash", "error": str(e), "timestamp": datetime.now().isoformat()}
                          continue
                      
                      if processed_count % 5 == 0:
                          save_store(store)
          except KeyboardInterrupt:
              print("\nlyrics: interrupted by user")
          finally:
              if skipped_count > 0:
                  print("Skipped %d paths." % skipped_count)
              print("lyrics: processed %d files, saving store..." % processed_count)
              save_store(store)
              print("lyrics: done.")
      
      def main():
          parser = argparse.ArgumentParser(
              description="Translate lyrics in flac files using DeepL API.\n"
                          "Keeps track of processed files inside `translations_store.json`."
          )
          parser.add_argument("-n", "--dry-run", action="store_true", help="show what would be translated without modifying files.")
          parser.add_argument("-f", "--force", action="store_true", help="force rechecking of all files even if processed before.")
          parser.add_argument("-d", "--directory", type=str, default=MUSIC_DIR, help="directory containing the flac files.")
          args = parser.parse_args()
      
          iterate_albums(directory=args.directory, dry_run=args.dry_run, force=args.force)
      
      if __name__ == "__main__":
          main()
    '';
  };

in
{
  # Copy the Python script into beets home
  system.activationScripts.setup-beets-translate = ''
    cp ${translateLyricsPy} ${beets-home}/translate-lyrics.py
    chown beets:music ${beets-home}/translate-lyrics.py
    chmod 750 ${beets-home}/translate-lyrics.py
  '';

  # Run with: `sudo -u beets translate-lyrics.py`
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "translate-lyrics" ''
      set -euo pipefail
      export DEEPL_AUTH_KEY="$(cat ${config.sops.secrets.deepl.path})"

      cd ${beets-home}
      ${pythonEnv}/bin/python ${beets-home}/translate-lyrics.py "$@" || true

      ${pkgs.beets}/bin/beet update
    '')
  ];
}