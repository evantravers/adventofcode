{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "";

  # https://devenv.sh/packages/
  packages = [ pkgs.git pkgs.lexical ];

  # https://devenv.sh/scripts/
  enterShell = ''
  '';

  # https://devenv.sh/languages/
  languages.elixir.enable = true;
}
