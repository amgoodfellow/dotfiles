{
  username,
  ...
}:
{
  # A helpful article: https://jvns.ca/blog/2024/02/16/popular-git-config-options/
  programs.git = {
    enable = true;
    settings = {
      user.name = "Aaron Goodfellow";
      user.email =
        if username == "agoodfellow" then "agoodfellow@nowsecure.com" else "amgoodfellow@protonmail.com";

      core.editor = "nvim";
      core.excludesfile = builtins.toString ./global-gitignore;
      core.fileMode = false;
      core.ignorecase = false;

      diff.algorithm = "histogram";

      github.user = "amgoodfellow";

      help.autocorrect = 10;

      init.defaultBranch = "main";

      pull.rebase = true;
      rerere.enabled = true;

      push.autoSetupRemote = true;

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
