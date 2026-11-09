{ config, lib, pkgs, ... }:

let
    cfg = config.programs.flex-launcher;

    # One "EntryN=title;icon;command" line per menu entry
    entries = lib.concatStringsSep "\n" (lib.imap1
        (i: e: "Entry${toString i}=${e.title};${e.icon};${e.command}")
        cfg.entries);

    # One "Button=action" line per gamepad control
    gamepadControls = lib.concatStringsSep "\n" (lib.mapAttrsToList
        (button: action: "${button}=${action}")
        cfg.gamepad.controls);

    # Launcher config, written to the Nix store
    launcherConfig = pkgs.writeText "flex-launcher.ini" ''
        [General]
        DefaultMenu=Main

        [Main]
        ${entries}

        [Gamepad]
        Enabled=${lib.boolToString cfg.gamepad.enable}
        ${gamepadControls}
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

        gamepad = {
            enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether the launcher can be driven with a gamepad.";
            };

            controls = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                # Same as the example config shipped with Flex Launcher
                default = {
                    "LStickX-" = ":left";
                    "LStickX+" = ":right";
                    ButtonA = ":select";
                    ButtonB = ":back";
                    ButtonDPadLeft = ":left";
                    ButtonDPadRight = ":right";
                };
                description = ''
                    Gamepad controls, button or axis name to command (usually a special
                    command such as :select or :back). Setting it replaces the defaults.
                '';
            };
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [ package ];
    };
}
