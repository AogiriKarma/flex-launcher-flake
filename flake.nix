{
    description = "NixOS module to configure Flex Launcher declaratively";

    outputs = { self }: {
        nixosModules.default = import ./module.nix;
    };
}
