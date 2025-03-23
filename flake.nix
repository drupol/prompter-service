{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.process-compose-flake.flakeModule
        inputs.pkgs-by-name-for-flake-parts.flakeModule
      ];

      perSystem =
        {
          self',
          pkgs,
          lib,
          config,
          ...
        }:
        {
          pkgsDirectory = ./pkgs;
          packages.default = self'.packages.prompter-service;

          process-compose."prompter-service" = pc: {
            imports = [
              inputs.services-flake.processComposeModules.default
              ./services/http-server.nix
            ];

            services.http-server = {
              enable = true;
              port = 1234;
              root = "${config.packages.prompter}/share/prompter";
            };

            settings.processes.open-browser = {
              command =
                let
                  opener = if pkgs.stdenv.isDarwin then "open" else lib.getExe' pkgs.xdg-utils "xdg-open";
                in
                "${opener} http://127.0.0.1:${builtins.toString pc.config.services.http-server.port}";
            };
          };
        };
    };
}
