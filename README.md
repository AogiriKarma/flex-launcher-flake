# flex-launcher-flake

NixOS module that turns a machine into a TV box: on boot, it logs a user in
and runs [Flex Launcher](https://github.com/complexlogic/flex-launcher)
fullscreen in [cage](https://github.com/cage-kiosk/cage), no desktop.

## Usage

```nix
# flake.nix
inputs.flex-launcher-flake.url = "github:AogiriKarma/flex-launcher-flake";

# a NixOS module
{ inputs, pkgs, ... }:
{
    imports = [ inputs.flex-launcher-flake.nixosModules.default ];

    tv.enable = true;
    tv.user = "karma";
    tv.entries = [
        { title = "Moonlight"; icon = ./moonlight.png; command = "moonlight"; }
    ];
}
```

## Options

- `tv.enable`: enable the kiosk session
- `tv.user`: user the session runs as
- `tv.entries`: main menu entries (`title`, `icon`, `command`), in order.
  `command` can be a program, a `.desktop` file or a Flex Launcher special
  command such as `:restart` or `:shutdown`
