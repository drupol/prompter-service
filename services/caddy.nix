{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    services.caddy = {
      enable = lib.mkEnableOption "Enable Caddy service";
      package = lib.mkPackageOption pkgs "caddy" { };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8080;
      };
      root = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config =
    let
      cfg = config.services.caddy;
    in
    lib.mkIf cfg.enable {
      settings.processes.caddy = {
        command = "${lib.getExe cfg.package} file-server --listen :${builtins.toString cfg.port} --root ${cfg.root}";
      };
    };
}
