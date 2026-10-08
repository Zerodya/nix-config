{
  sops.secrets.discord-webhook = {
    sopsFile = ../../../../secrets/discord-webhook.yaml;
    key = "url";
    mode = "0400"; # root only, read by notify-discord@ via LoadCredential
  };
}
