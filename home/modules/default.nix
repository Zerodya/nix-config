{
  
  imports = [
    ./gaming.nix
  ];

  # TODO use gaming only on desktop

  # 1. create an `enable` option
  # 2. Wrap everything in a `config = mkIf`
  # 3. enable the thing on only the desktop
  # The best way to achieve that is by starting to use seperate entrypoints for each host/user combination 
}