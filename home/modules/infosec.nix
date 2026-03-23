{ pkgs, ...}:
{
  home.packages = with pkgs; [
    # Network
    nmap

    # Binary
    gdb
    ghidra-bin
    wxhexeditor
    okteta
    pince

    # Bruteforcing
    seclists
  ];
}