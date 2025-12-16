{ pkgs, ... }:

{
  home.packages = with pkgs; [
    beets
    flac
  ];

  # Beets configuration
  home.file.".config/beets/config.yaml".source = ./beets-config.yaml;

  # Functions
  programs.fish = {
    functions = {
      flac-read = {
        # Read tags from flac files in a directory
        body = ''
          if test (count $argv) -ne 2
            echo "Usage: flac-read <directory> <tag>"
            return 1
          end

          metaflac --list $argv[1]/*.flac | grep -i $argv[2]
        '';
      };

      flac-write = {
        # Overwrite tags of flac files in a directory
        body = ''
          if test (count $argv) -ne 3
            echo "Usage: flac-write <directory> <tag> <value>"
            return 1
          end

          metaflac --remove-tag=$argv[2] --set-tag="$argv[2]=$argv[3]" $argv[1]/*.flac
        '';
      };
    };
  };

}