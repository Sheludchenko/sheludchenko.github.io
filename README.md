# Prerequisites for Ubuntu 20.04

```
# dotnet sdk 6 prerequisites
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo apt-get update

# dotnet sdk 6
sudo apt-get install -y dotnet-sdk-6.0

# retypeapp tool
dotnet tool install retypeapp --global
```

# Local development

```
retype watch
```