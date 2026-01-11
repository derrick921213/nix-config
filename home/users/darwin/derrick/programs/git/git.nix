{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "dlin12457@gmail.com";
        name = "derrick921213";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
