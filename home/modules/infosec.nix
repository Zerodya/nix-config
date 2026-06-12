{ pkgs, ...}:
{
  home.packages = with pkgs; [
    # Network
    nmap
    wireshark

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