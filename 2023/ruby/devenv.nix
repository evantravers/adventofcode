{ pkgs, ... }:

{
  # https://devenv.sh/basics/

  # https://devenv.sh/packages/
  packages = [ pkgs.git pkgs.solargraph ];

  # https://devenv.sh/scripts/

  # https://devenv.sh/languages/
  languages.ruby.enable = true;

  # https://devenv.sh/pre-commit-hooks/

  # https://devenv.sh/processes/

  # See full reference at https://devenv.sh/reference/options/
}
