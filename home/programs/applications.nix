{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    brave
    tor-browser
    
    # Chats
    discord
    vesktop
    beeper

    # Media
    spotify
    feishin
    youtube-music
    freetube
    mpv
    vlc

    # Media Editing
    krita
    kdePackages.kdenlive

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
    #yabridge
    #yabridgectl
    neural-amp-modeler-lv2

    # Audio tools
    pavucontrol
    qjackctl
    easyeffects

    # Network
    networkmanagerapplet
    
    # PDF
    kdePackages.okular

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

    # Focus
    gnome-solanum # Pomodoro timer
    blanket # White/Brown noise
  ];
}