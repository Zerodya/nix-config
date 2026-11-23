{ lib, pkgs, ... }:
{
  # Based on https://ibborarts.github.io/exp/experiment-001.html (same GPU)
  services.llama-cpp = {
    enable = true;
    # gfx1031 has no ROCm kernels: build for gfx1030 only and override the reported version below
    package = pkgs.llama-cpp.override {
      rocmSupport = true;
      rocmGpuTargets = [ "gfx1030" ];
    };
    settings = {
      # Heretic uncensored Qwen3.6, 12.7 GiB: ~8 on GPU, the rest fits in RAM next to the desktop. IQ4_NL (16.8 GiB) thrashed the SSD with 16GB RAM
      hf-repo = "mradermacher/Qwen3.6-35B-A3B-uncensored-heretic-i1-GGUF"; # downloaded to /var/cache/llama-cpp on first start
      hf-file = "Qwen3.6-35B-A3B-uncensored-heretic.i1-IQ3_XXS.gguf";
      no-mmproj = true; # text only, saves VRAM
      load-mode = "none"; # with mmap, ROCm hit a GPU memory access fault copying weights to VRAM
      ctx-size = 65536; # room for MCP tool schemas (GhydraMCP ~8K tokens) + tool results; 128K cost ~2GB VRAM
      flash-attn = "on";
      threads = 4;
      threads-batch = 4;
      parallel = 1;
      # GPU layers / CPU-offloaded MoE experts are picked by --fit (default on).
      # Manual fallback from the article: n-gpu-layers = 99; n-cpu-moe = 26;
      fit-target = 2048; # MiB of VRAM left free on top of what's in use at start, so the desktop can still grow

      temp = 0.6;
      top-k = 20;
      top-p = 0.95;
      min-p = 0;
    };
  };
  systemd.services.llama-cpp = {
    wantedBy = lib.mkForce [ ]; # manual only: `sudo systemctl start llama-cpp` / `stop` to free VRAM
    environment.HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # RX 6700XT
    serviceConfig = {
      SupplementaryGroups = [ "render" ];
      TimeoutStopSec = 10; # llama-server hangs in ROCm teardown on SIGTERM; nothing to save, kill it fast
    };
  };

  services.open-webui = {
    enable = true;
    port = 11111;
    environment = {
      ENABLE_OLLAMA_API = "False";
      OPENAI_API_BASE_URL = "http://127.0.0.1:8080/v1";
      OPENAI_API_KEY = "sk-local";
    };
  };

  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    # ROCm
    rocmPackages.rocm-smi
    rocmPackages.rocminfo

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
