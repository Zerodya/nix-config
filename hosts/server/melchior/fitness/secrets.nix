{config, ...}:

{
  sops.secrets = {
    sf-db-pw = {
      sopsFile = ../../../../secrets/fitness/sparkyfitness.yaml;
      format = "yaml";
      key = "sf-db-pw";
    };
    sf-app-db-pw = {
      sopsFile = ../../../../secrets/fitness/sparkyfitness.yaml;
      format = "yaml";
      key = "sf-app-db-pw";
    };
    sf-api-key = {
      sopsFile = ../../../../secrets/fitness/sparkyfitness.yaml;
      format = "yaml";
      key = "sf-api-key";
    };
    sf-auth-secret = {
      sopsFile = ../../../../secrets/fitness/sparkyfitness.yaml;
      format = "yaml";
      key = "sf-auth-secret";
    };
  };

  sops.templates."sparkyfitness.env" = {
    content = ''
      POSTGRES_DB=sparkydb
      POSTGRES_USER=sparky
      POSTGRES_PASSWORD=${config.sops.placeholder.sf-db-pw}

      SPARKY_FITNESS_DB_USER=sparky
      SPARKY_FITNESS_DB_NAME=sparkydb
      SPARKY_FITNESS_DB_HOST=localhost
      SPARKY_FITNESS_DB_PORT=5432
      SPARKY_FITNESS_DB_PASSWORD=${config.sops.placeholder.sf-db-pw}

      SPARKY_FITNESS_APP_DB_USER=sparkyapp
      SPARKY_FITNESS_APP_DB_PASSWORD=${config.sops.placeholder.sf-app-db-pw}

      SPARKY_FITNESS_API_ENCRYPTION_KEY=${config.sops.placeholder.sf-api-key}
      BETTER_AUTH_SECRET=${config.sops.placeholder.sf-auth-secret}

      SPARKY_FITNESS_FRONTEND_URL=http://192.168.1.201:3004
      SPARKY_FITNESS_SERVER_HOST=localhost
      SPARKY_FITNESS_SERVER_PORT=3010
    '';
  };

  sops.secrets.cloudflared-fitness = {
    sopsFile = ../../../../secrets/fitness/cloudflared-fitness.yaml;
    key = "cloudflared-fitness";
    mode = "0400";
  };

}