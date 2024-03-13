{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    floorp
    brave
    firefox
    tor-browser
    
    # Chats
    beeper
    discord
    vesktop
    telegram-desktop

    # Media
    spotify
    freetube
    youtube-music
    mpv
    vlc

    # Media Editing
    krita
    libsForQt5.kdenlive

    # Uni
    teams-for-linux

    # Office
    libreoffice
    onlyoffice-bin

    # File Editing / IDE
    vscodium-fhs
    sublime4
    obsidian
    
    # Drawing
    lorien

    # Guitar
    tonelib-gfx
    tonelib-jam
    
    # PDF
    libsForQt5.okular

    # Theming
    gradience
    
    # Screen Rec
    obs-studio

    # Backup
    pika-backup

    # Downloading
    qbittorrent

    # LSP
    nil
  ];
}