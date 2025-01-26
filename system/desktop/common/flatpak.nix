{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };

    packages = [
      "flathub:app/com.github.tchx84.Flatseal//stable" # Flatseal
      "flathub:app/com.usebottles.bottles//stable" # Bottles
    ];

    overrides = {
      "global" = {
        filesystems = [
          "/home/alpha/.themes/adw-gtk3:ro"
        ];
        environment = {
          "GTK_THEME" = "adw-gtk3";
        };
      };
    };
    
  };

}