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
    home.stateVersion = "23.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.bash = {
        enable = false;
        bashrcExtra = ''
            eval "$(direnv hook bash)"
            eval "$(zoxide init bash)"
            alias cd='z' 
        ''; 
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
            eval "$(direnv hook zsh)"
            eval "$(zoxide init zsh)"
            alias cd='z' 
        ''; 

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --impure";
        p = "python";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };

      history.size = 10000;
    };

    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        include current-theme.conf
        confirm_os_window_close 0
        font_size 13.0
        shell zsh
        enable_audio_bell no
      '';
    };

    programs.direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        enableZshIntegration = true;
        nix-direnv.enable = true;
        # dependant on bash being enabled above
    };
  };
}