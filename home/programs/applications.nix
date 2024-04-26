{ pkgs, ... }:

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
    
    # PDF
    libsForQt5.okular

    # Theming
    gradience
    lxappearance
    nwg-look
    
    # Screen Rec
    obs-studio

    # Webcam
    gnome.cheese

    # Backup
    pika-backup

    # Downloading
    qbittorrent

    # Nix language server
    nil

    # Disks
    gparted

    # Container
    distrobox
  ];
}