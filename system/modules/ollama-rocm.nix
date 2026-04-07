{ pkgs, ... }:
let
  ttsSanitizer = pkgs.writers.writePython3Bin "tts-sanitizer" {
    libraries = with pkgs.python3Packages; [ fastapi uvicorn httpx ];
    flakeIgnore = [ "E501" "W291" "W293" "E302" "E305" "E231" ];
  } ''
    import re
    import httpx
    import json
    import html
    from fastapi import FastAPI, Request, Response
    import uvicorn

    app = FastAPI()
    TTS_BASE_URL = "http://127.0.0.1:8002"

    def sanitize_latex(text):
        # Decodifica HTML entities se presenti
        text = html.unescape(text)
        
        # FASE 1: Rimuovi delimitatori LaTeX espliciti
        text = re.sub(r'\\\[', ' ', text)
        text = re.sub(r'\\\]', ' ', text)
        text = re.sub(r'\\\(', ' ', text)
        text = re.sub(r'\\\)', ' ', text)
        text = re.sub(r'\$\$', ' ', text)
        
        # FASE 2: Gestione valore assoluto
        text = re.sub(r'(\||\u2223|\u007C|\u2016)([^|\u2223\u007C\u2016\s]+?)\1', r' modulo di \2 ', text)
        # Rimuovi barre orfane
        text = re.sub(r'\||\u2223|\u007C|\u2016', ' ', text)
        
        # FASE 3: Sostituzioni LaTeX -> Italiano
        greek = {
            'alpha': 'alfa', 'beta': 'beta', 'gamma': 'gamma',
            'delta': 'delta', 'epsilon': 'epsilon', 'zeta': 'zeta',
            'eta': 'eta', 'theta': 'teta', 'iota': 'iota',
            'kappa': 'kappa', 'lambda': 'lambda', 'mu': 'mu',
            'nu': 'nu', 'xi': 'csi', 'pi': 'pigreco',
            'rho': 'ro', 'sigma': 'sigma', 'tau': 'tau',
            'upsilon': 'ipsilon', 'phi': 'fi', 'chi': 'chi',
            'psi': 'psi', 'omega': 'omega',
        }
        
        # Comandi LaTeX comuni
        text = re.sub(r'\\([a-zA-Z]+)', lambda m: ' ' + greek.get(m.group(1), m.group(1)) + ' ', text)
        
        # Simboli matematici
        text = re.sub(r'\\leq|\\le', ' minore o uguale a ', text)
        text = re.sub(r'\\geq|\\ge', ' maggiore o uguale a ', text)
        text = re.sub(r'\\neq|\\ne', ' diverso da ', text)
        text = re.sub(r'\\approx', ' circa ', text)
        text = re.sub(r'\\times|\\cdot', ' per ', text)
        text = re.sub(r'\\div', ' diviso ', text)
        text = re.sub(r'\\pm', ' piu o meno ', text)
        text = re.sub(r'\\frac\{([^}]+)\}\{([^}]+)\}', r' \1 fratto \2 ', text)
        text = re.sub(r'\\sqrt\{([^}]+)\}', r' radice di \1 ', text)
        text = re.sub(r'\\sqrt', ' radice ', text)
        text = re.sub(r'\\sum', ' somma ', text)
        text = re.sub(r'\\int', ' integrale ', text)
        text = re.sub(r'\\infty', ' infinito ', text)
        text = re.sub(r'\\to|\\rightarrow', ' tende a ', text)
        text = re.sub(r'\\forall', ' per ogni ', text)
        text = re.sub(r'\\exists', ' esiste ', text)
        text = re.sub(r'\\in', ' appartiene a ', text)
        
        # FASE 4: Apici e pedici
        text = re.sub(r'\^([a-zA-Z0-9])', r' alla \1 ', text)
        text = re.sub(r'_([a-zA-Z0-9])', r' pedice \1 ', text)
        
        # FASE 5: Pulizia finale
        text = text.replace('{', ' ').replace('}', ' ')
        text = text.replace('<', ' minore di ').replace('>', ' maggiore di ')
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text


    @app.api_route("/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD", "PATCH"])
    async def proxy(request: Request, path: str):
        target_url = f"{TTS_BASE_URL}/{path}"
        body = None
        
        if request.method in ["POST", "PUT", "PATCH"]:
            body = await request.body()
            if body:
                try:
                    data = json.loads(body)
                    if isinstance(data, dict) and "input" in data:
                        original = data["input"]
                        pulito = sanitize_latex(original)
                        if original != pulito:
                            print(f"Sanitized: {original[:50]}... -> {pulito[:50]}...")
                        data["input"] = pulito
                        body = json.dumps(data, ensure_ascii=False).encode('utf-8')
                except Exception as e:
                    print(f"Error: {e}")
        
        headers = dict(request.headers)
        headers.pop("host", None)
        headers.pop("content-length", None)
        
        async with httpx.AsyncClient() as client:
            try:
                if request.method == "GET":
                    resp = await client.get(target_url, headers=headers, params=request.query_params)
                elif request.method == "POST":
                    resp = await client.post(target_url, headers=headers, content=body)
                else:
                    resp = await client.request(request.method, target_url, headers=headers, content=body)
                
                return Response(
                    content=resp.content,
                    status_code=resp.status_code,
                    headers=dict(resp.headers)
                )
            except Exception as e:
                return Response(content=str(e).encode(), status_code=500)


    if __name__ == "__main__":
        uvicorn.run(app, host="127.0.0.1", port=8001)
  '';
in
{
  services.open-webui = {
    enable = true;
    port = 11111;
    environment = {
      AUDIO_TTS_ENGINE = "openai";
      AUDIO_TTS_OPENAI_API_BASE_URL = "http://127.0.0.1:8001/v1";
      AUDIO_TTS_OPENAI_API_KEY = "sk-local";
      AUDIO_TTS_MODEL = "tts-1";
      AUDIO_TTS_VOICE = "it-IT-ElsaNeural";

      TTS_ENGINE = "openai";
      TTS_OPENAI_API_BASE_URL = "http://127.0.0.1:8001/v1";
      TTS_OPENAI_API_KEY = "sk-local";
      TTS_MODEL = "tts-1";
      TTS_VOICE = "it-IT-ElsaNeural";

      AUDIO_STT_ENGINE = "openai";
      AUDIO_STT_OPENAI_API_BASE_URL = "http://127.0.0.1:8000/v1";
      AUDIO_STT_OPENAI_API_KEY = "sk-local";
      AUDIO_STT_MODEL = "whisper-1";

      STT_ENGINE = "openai";
      STT_OPENAI_API_BASE_URL = "http://127.0.0.1:8000/v1";
      STT_OPENAI_API_KEY = "sk-local";
      STT_MODEL = "whisper-1";

      ENABLE_VOICE_CALL = "true";
      ENABLE_CONFERENCE_MODE = "true";
    };
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [ "llama3.2" ];
  };

  hardware.amdgpu.opencl.enable = true;
  virtualisation.containers.enable = true;
  virtualisation.oci-containers.backend = "podman";

  # STT
  virtualisation.oci-containers.containers.whisper-stt = {
    image = "fedirz/faster-whisper-server:latest-cpu";
    autoStart = true;
    ports = [ "127.0.0.1:8000:8000" ];
    environment = {
      WHISPER_MODEL = "small";
      WHISPER_LANGUAGE = "it";
      WHISPER_DEVICE = "cpu";
    };
  };

  # TTS
  virtualisation.oci-containers.containers.openai-edge-tts = {
    image = "docker.io/travisvn/openai-edge-tts:latest";
    autoStart = true;
    ports = [ "127.0.0.1:8002:5050" ]; 
    environment = {
      DEFAULT_VOICE = "it-IT-ElsaNeural";
      DEFAULT_LANGUAGE = "it-IT";
      DEFAULT_RESPONSE_FORMAT = "mp3";
      DEFAULT_SPEED = "1.0";
      API_KEY = "sk-local";
      REQUIRE_API_KEY = "True";
      EXPAND_API = "True";
    };
  };

  systemd.services.tts-sanitizer = {
    description = "TTS LaTeX Sanitizer";
    after = [ "network.target" "podman-openai-edge-tts.service" ];
    bindsTo = [ "podman-openai-edge-tts.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${ttsSanitizer}/bin/tts-sanitizer";
      Restart = "always";
      RestartSec = "5";
    };
  };

  environment.systemPackages = with pkgs; [
    # ROCm
    rocmPackages.rocm-core
    rocmPackages.rocm-runtime
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    
    # Container tools
    podman
    podman-compose
    
    # Other
    uv
  ];

  # GLaDOS ( git clone https://github.com/dnhkng/GLaDOS )
  programs.nix-ld = {
    enable = true;
    # Inside the cloned repo:
    # Install with: `LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH steam-run python scripts/install.py`
    # Run with: `LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH steam-run uv run glados tui`
    libraries = with pkgs; [
      portaudio
      onnx
      onnxruntime
    ];
  };
}