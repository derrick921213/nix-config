{...}: {
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "libsecret";
      user = {
        email = "dlin12457@gmail.com";
        name = "derrick921213";
      };
      init = {
        defaultBranch = "main";
      };
      alias = {
        st = "status";
        co = "checkout";
        ci = "commit";
        br = "branch";
        lg = "log --graph --oneline --all";
      };
    };
  };
}
