{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    floorp
    brave
    tor-browser
    
    # Chats
    discord
    vesktop

    # Media
    spotify
    feishin
    youtube-music
    freetube
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
    reaper
    neural-amp-modeler-lv2

    # Audio tools
    pavucontrol
    qjackctl
    easyeffects

    # Network
    networkmanagerapplet
    
    # PDF
    libsForQt5.okular

    # Theming
    gradience
    lxappearance
    nwg-look
    
    # Screen Rec
    obs-studio

    # Webcam
    cheese

    # Backup
    pika-backup
    btrfs-assistant

    # Downloading
    qbittorrent

    # Nix language server
    nixd

    # Disks
    gparted

    # Pomodoro
    gnome-solanum
  ];
}