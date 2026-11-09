{ config, lib, pkgs, ... }:

let
    # One "EntryN=title;icon;command" line per menu entry
    entries = lib.concatStringsSep "\n" (lib.imap1
        (i: e: "Entry${toString i}=${e.title};${e.icon};${e.command}")
        config.tv.entries);

    # Launcher config, written to the Nix store
    launcherConfig = pkgs.writeText "flex-launcher.ini" ''
        [General]
        DefaultMenu=Main

        [Main]
        ${entries}

        [Gamepad]
        Enabled=true
    '';
in
{
    options.tv = {
        enable = lib.mkEnableOption "the TV kiosk session (Flex Launcher in cage)";

        user = lib.mkOption {
            type = lib.types.str;
            description = "User the TV session runs as.";
        };

        entries = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {
                options = {
                    title = lib.mkOption { type = lib.types.str; };
                    icon = lib.mkOption { type = lib.types.path; };
                    command = lib.mkOption { type = lib.types.str; };
                };
            });
            default = [ ];
            description = "Main menu entries, in display order.";
        };
    };

    config = lib.mkIf config.tv.enable {
        services.cage = {
            enable = true;
            program = "${pkgs.flex-launcher}/bin/flex-launcher -c ${launcherConfig}";
            user = config.tv.user;
        };
    };
}
