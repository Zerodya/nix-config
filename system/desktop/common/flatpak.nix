{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };

    packages = [
      # Flatseal
      "flathub:app/com.github.tchx84.Flatseal//stable"

      # Bottles
      "flathub:app/com.usebottles.bottles//stable" 
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope//24.08" # Gamescope
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud//24.08" # MangoHUD
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt//24.08" # vkBasalt
    ];
  };
}