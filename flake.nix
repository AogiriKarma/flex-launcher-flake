{
    description = "NixOS module: TV kiosk session running Flex Launcher in cage";

    outputs = { self }: {
        nixosModules.default = import ./module.nix;
    };
}
