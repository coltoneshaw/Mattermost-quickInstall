# Mattermost-quickInstall
A quick install script for setting up a local mattermost server.

SCP the file onto your server.

AWS:
```bash
    scp -i "~/yourkey.pem" -r ./* ubuntu@ecx-x-x-x.us-east-2.compute.amazonaws.com:~
```

Other servers:
```bash
    scp -r ./* ubuntu@ip:~
```