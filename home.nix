{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.josiah = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "21.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.bash = {
        enable = true;
        bashrcExtra = ''
            eval "$(direnv hook bash)"
            eval "$(zoxide init bash)"
            alias cd='z' 
        ''; 
    };
  };
}