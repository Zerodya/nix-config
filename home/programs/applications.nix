{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # DE apps
    sushi # preview for nautilus
    loupe # image viewer
    gnome-calculator
    gnome-disk-utility
    baobab # disk usage analyzer

    # Browsers
    brave
    tor-browser
    
    # Chats
    discord
    vesktop
    signal-desktop

    # Media
    feishin
    pear-desktop
    freetube
    mpv
    celluloid
    vlc

    # Media Editing
    krita
    kdePackages.kdenlive
    upscayl

    # Uni
    teams-for-linux

    # Office
    libreoffice
    onlyoffice-desktopeditors

    # File Editing / IDE
    vscodium-fhs
    kdePackages.kate
    zed-editor
    obsidian
    
    # To-do 
    planify
    
    # Drawing
    lorien

    # Audio tools
    pwvucontrol
    qpwgraph
    easyeffects

    # Network
    networkmanagerapplet
    
    # PDF
    kdePackages.okular
    
    # Screen Rec
    obs-studio

    # Webcam
    cheese

    # Backup
    pika-backup
    btrfs-assistant

    # Downloading
    qbittorrent

    # Disks
    gparted

    # Focus
    gnome-solanum # Pomodoro timer
    blanket # White/Brown noise
  ];
}