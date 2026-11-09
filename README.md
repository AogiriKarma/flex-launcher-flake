# flex-launcher-flake

NixOS module to configure [Flex Launcher](https://github.com/complexlogic/flex-launcher)
declaratively. It installs a `flex-launcher` command that starts with the
generated config, so it can be launched from anywhere: a desktop, a shortcut,
or a kiosk compositor like cage.

## Usage

```nix
# flake.nix
inputs.flex-launcher-flake.url = "github:AogiriKarma/flex-launcher-flake";

# a NixOS module
{ inputs, ... }:
{
    imports = [ inputs.flex-launcher-flake.nixosModules.default ];

    programs.flex-launcher = {
        enable = true;
        entries = [
            { title = "Spotify"; icon = ./spotify.png; command = "spotify"; }
            { title = "Shutdown"; icon = ./power.png; command = ":shutdown"; }
        ];
    };
}
```

## Options

- `programs.flex-launcher.enable`: install the configured `flex-launcher` command
- `programs.flex-launcher.entries`: main menu entries (`title`, `icon`,
  `command`), in order. `command` can be a program, a `.desktop` file or a
  Flex Launcher special command such as `:restart` or `:shutdown`
