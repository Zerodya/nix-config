{ appimageTools, fetchurl }:

let
  pname = "keypeek";
  version = "0.11.1";
  src = fetchurl {
    url = "https://github.com/srwi/keypeek/releases/download/${version}/keypeek-v${version}-linux-x86_64.AppImage";
    hash = "sha256-QdSVWfkrB7e0/LxE7j9RZ4tAylRGrsIuTarnxne3DMs=";
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${contents}/cargo-appimage.desktop $out/share/applications/keypeek.desktop
    install -Dm444 ${contents}/keypeek.png $out/share/icons/hicolor/256x256/apps/keypeek.png
  '';
}
