{
  sops.secrets.cloudflared-blog = {
    sopsFile = ../../../../secrets/blog/cloudflared-blog.yaml;
    key = "cloudflared-blog";
    mode = "0400";
  };
}
