# Mattermost-quickInstall
A quick install script for setting up a local mattermost server.

## Setup

1. Download the git file onto your server

    ```
    git clone https://github.com/coltoneshaw/matterhelp
    ```

2. Setup your `config.json` file located in the `matterhelp` root

    Using the `config.json` will override the defaults within the commands. It's optional but suggested. 

    ```jsonc
    {
        "version" : "latest", // latest or a valid version string. All three required. Ex: 6.2.0 vs 6.2 
        "saml": true, // uses keycloak. Requires some additional setup.
        "siteURL" : "",
        "ldap": {
            "enable" : true,
            "numUsers" : 10000,
            "numGroups" : 500
        },
        "nginx" : true, // sets up the nginx docker image to route to Mattermost.
        "databaseDriver" : "postgres", // postgres or mysql
        "metrics" : true, // enables the 8067 port and setups prometheus / grafana
        "licenseFile" : "mattermost-license.license" // file string. Just store within the directory itself.
    }
    ```


3. Run the setup script

    Runs `apt update`, downloads `jq` and makes the `matterhelp` file executable. 
    
    ```
    sudo bash setup/initialSetup.sh
    ```

-------------
SCP the file onto your server.

AWS:
```bash
    scp -i "~/yourkey.pem" -r ./* ubuntu@ecx-x-x-x.us-east-2.compute.amazonaws.com:~
```

Other servers:
```bash
    scp -r ./* ubuntu@ip:~
```




