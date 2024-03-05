# Nixos configs
## About
NixOS allows for an operating system to be declared.

It's especially useful for duplicating your desktop setup on another machine, or streamlining the reinstall proccess on a bricked/brokeb machine. 

Feel free to use these samples as starting point for your NixOS config.

## Suggested setup
Upon install Nixos, the default configuration file is in `/etc/nixos`.
I recommend setting up `/etc/nixos` as a git repository and periodically committing changes to remote. 



## Use Guide
Make changes to configuration.nix


Apply the changes:

`sudo nixos-rebuild switch`

The installed programs can now be used, but a full restart is required for a complete update.

## Examples
`configuration.nix` is a default config on my laptop used for software developement. 
It includes tools for software developement, productivity, power control settings. 
Declaritive settings for GNOME desktop, extensions, and desktop apps are included.

`media-server.nix` is a setup used on an old laptop to turn it into a "smart" TV. 
Includes programs are GS Connect for turning a phone into remote input, a variety of streaming apps and tuned power settings.