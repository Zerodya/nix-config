{ pkgs, ...}:
{
  home.packages = with pkgs; [
    # Network
    nmap
    wireshark

    # Disassemblers
    ghidra
    ghidra-extensions.kaiju
    ghidra-extensions.ret-sync

    # Debuggers
    gdb
    #pince
    strace
    ltrace
    file

    # Hex editors
    okteta
    imhex

    # Bruteforcing
    seclists
  ];
}