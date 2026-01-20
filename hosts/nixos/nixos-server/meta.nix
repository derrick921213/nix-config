{...}: {
  system = "aarch64-linux";
  user = "derrick";
  deployment = {
    targetHost = "172.16.125.137";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
