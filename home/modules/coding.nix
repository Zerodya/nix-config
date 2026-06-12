{ pkgs, ...}:
{
  home.packages = with pkgs; [
    gcc

    # Rust
    cargo
    rustlings
  ];
}