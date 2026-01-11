{ pkgs, ... }:
{
  # Ollama with Open WebUI
  services.open-webui.enable = true;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  # ROCm
  hardware.amdgpu.opencl.enable = true;
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-core
    rocmPackages.rocm-runtime
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];
}