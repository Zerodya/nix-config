{ pkgs, ... }:
{
  # Ollama with Open WebUI
  services.open-webui.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  # ROCm
  hardware.amdgpu.opencl.enable = true;
  environment.systemPackages = with pkgs.rocmPackages; [
    # Core ROCm stack
    rocm-core
    rocm-runtime
    rocm-device-libs
    rocm-comgr
    rocm-cmake

    # Math libraries
    rocblas
    hipblas
    rocsparse
    rocsolver
    rocrand
    hipsparse
    miopen
    rocfft
    hipfft

    # HIP toolchain
    hipcc
    hip-common
    hipfort
    
    # Runtime components
    rccl
    rocthrust
    rocprim
    hipcub

    # Monitoring/debugging
    rocm-smi
    rocminfo

    # Low-level dependencies
    half
    hsa-amd-aqlprofile-bin
  ];

}