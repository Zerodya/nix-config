{ pkgs, ... }:
{
  # Ollama with Open WebUI
  services.open-webui.enable = true;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [ "llama3.2" ];
  };

  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    # ROCm
    rocmPackages.rocm-core
    rocmPackages.rocm-runtime
    rocmPackages.rocm-smi
    rocmPackages.rocminfo

    # TTS
    nur.repos.xddxdd.openedai-speech

    # Other tools
    uv
  ];

  # GLaDOS at https://github.com/dnhkng/GLaDOS
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