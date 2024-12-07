{
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;

    settings = {
      # CF public DNS
      server = [ "2606:4700:4700::1111" "2606:4700:4700::1001" ];

      port = 53;
      domain-needed = true;
      bogus-priv = true;
      dnssec = true;
      no-resolv = true;
      no-poll = true;
      bind-interfaces = true;
      local = "/home/";
      domain = "home";
    };
  };
}
