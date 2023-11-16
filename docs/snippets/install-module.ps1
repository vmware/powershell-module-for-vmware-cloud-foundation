Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name VMware.PowerCLI -MinimumVersion 12.3.0  -Repository PSGallery
Install-Module -Name PowerVCF -Repository PSGallery
