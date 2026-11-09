{ config, lib, pkgs, ... }:

let
    cfg = config.programs.flex-launcher;

    # One "EntryN=title;icon;command" line per menu entry
    entries = lib.concatStringsSep "\n" (lib.imap1
        (i: e: "Entry${toString i}=${e.title};${e.icon};${e.command}")
        cfg.entries);

    # Launcher config, written to the Nix store
    launcherConfig = pkgs.writeText "flex-launcher.ini" ''
        [General]
        DefaultMenu=Main

        [Main]
        ${entries}

        [Gamepad]
        Enabled=true
    '';

    package = pkgs.writeShellScriptBin "flex-launcher" ''
        exec ${pkgs.flex-launcher}/bin/flex-launcher -c ${launcherConfig} "$@"
    '';
in
{
    options.programs.flex-launcher = {
        enable = lib.mkEnableOption "Flex Launcher";

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

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [ package ];
    };
}
