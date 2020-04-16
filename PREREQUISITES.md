# Prerequisites

* For module 1 on Docker fundamentals, follow the instructions in the Docker section below. 
* For module 2 on Kubernetes, follow the instructions in the Kubernetes section below.

## Docker

### Windows users 

1. Install Docker for Windows

    * Verify that Hyper-V virtualisation is supported:

        ```console
        systeminfo
        ```

        If you see the following output, virtualization is supported on Windows.

        ```console
        Hyper-V Requirements:     VM Monitor Mode Extensions: Yes
                                  Virtualization Enabled In Firmware: Yes
                                  Second Level Address Translation: Yes
                                  Data Execution Prevention Available: Yes
        ```

        If you see the following output, your system already has a hypervisor installed and you can skip the next step.

        ```console
        Hyper-V Requirements:     A hypervisor has been detected. Features required for Hyper-V will not be displayed.
        ```

    * Download Docker from <https://docs.docker.com/docker-for-windows/install/>
    * Switch Docker engine to Linux containers (right-click on Docker icon in your system tray)
    * As an administrator, in a PowerShell terminal, run:

        ```console
        Set-NetConnectionProfile -interfacealias "vEthernet (DockerNAT)" -NetworkCategory Private
        ```

    * Right-click the Docker icon in your notification area > Preferences > Shared Drives, select your drive and click "Reset credentials", then "Apply". This will prompt you for your Windows credentials.

### MacOS users 

1. Install Docker from <https://docs.docker.com/docker-for-mac/install/>
2. Disable Kubernetes in the Docker preferences. Docker > Preferences > Kubernetes > (Uncheck) Enable Kubernetes.

## VSCode and extensions

In addition to the software above, you'll need an editor like [Visual Studio Code](https://code.visualstudio.com/).
You might want to install the following Docker and Kubernetes extensions for code completion and highlighting:
- Cloud code: `code --install-extension googlecloudtools.cloudcode`
- Docker: `code --install-extension ms-azuretools.vscode-docker`
- YAML: `code --install-extension redhat.vscode-yaml`


## Kubernetes

### Windows

1. Disable Kubernetes in the Docker preferences. Right-click the Docker icon in your notification area > Preferences > Kubernetes > (Uncheck) Enable Kubernetes.
2. Install the following packages with [Chocolatey](https://chocolatey.org):

    ```console
    choco upgrade minikube
    choco upgrade kubernetes-helm
    choco upgrade kubernetes-cli
    ```

### MacOS

   Install the following packages with [Homebrew](https://brew.sh):

    ```console
    brew install \
        kubernetes-cli \
        kubernetes-helm

    brew cask install \
        minikube \
        virtualbox
    ```

   If this is your first time using VirtualBox, you will need to approve its kernel extension. Open VirtualBox from your Applications folder, then open System Preferences and go to Security & Privacy and switch to the General tab.

   If there is a message that software from Oracle (the distributors of VirtualBox) has been blocked, you will need to click Allow and then restart your computer in order for VirtualBox to function correctly:
   
   ![image](https://developer.apple.com/library/archive/technotes/tn2459/Art/tn2459_approval.png)  


### Local cluster with minikube
    
* Try to create a local test cluster with:

    ```console
    # Windows only
    minikube start -p k8scluster --vm-driver hyperv --hyperv-virtual-switch "Default Switch"

    # MacOS only
    minikube start -p k8scluster
    ```

* If this succeeds, delete the cluster with `minikube delete -p k8scluster`.

## Cloud tools

Module 2 on Kubernetes will use a managed Kubernetes services provisioned in one of the following Cloud providers.

Ask you trainers which platform you will be using and install the following CLI tools accordingly.

### AWS

   ```
   # Windows
   choco upgrade awscli

   # MacOS
   brew cask install awscli
   ```

### Azure

   ```
   # Windows
   choco upgrade azure-cli

   # MacOS
   brew cask install azure-cli
   ```

### GCP 

   ```
   # Windows
   choco upgrade gcloudsdk

   # MacOS
   brew cask install google-cloud-sdk
   ```

Configure access to GCP:

* Log in to GCP with `gcloud auth login`. You'll need to log in with a Google account linked to the email address that these instructions were sent to.
* Configure your local Docker installation to use GCP's authentication mechanism when needed: `gcloud auth configure-docker`
