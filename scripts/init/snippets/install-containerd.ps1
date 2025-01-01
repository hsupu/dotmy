param(
    [string]$Version = "1.7.20" # update to your preferred version
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

$Arch = "amd64" # arm64 also available

$InstallDir = "$($env:ProgramFiles)\containerd"

# If containerd previously installed run:
Stop-Service -ErrorAction Continue containerd

# Download and extract desired containerd Windows binaries

& curl.exe -L https://github.com/containerd/containerd/releases/download/v$Version/containerd-$Version-windows-$Arch.tar.gz -o containerd-$Version-windows-$Arch.tar.gz
& tar.exe xvf .\containerd-$Version-windows-$Arch.tar.gz

Copy-Item -ErrorAction Stop ".\bin" $InstallDir -Recurse -Force

function GenDefaultConfig {
    $configPath = "$InstallDir\config.toml"
    & containerd.exe config default | Out-File $configPath -Encoding utf8

    # Review the configuration. Depending on setup you may want to adjust:
    # - the sandbox_image (Kubernetes pause image)
    # - cni bin_dir and conf_dir locations
}

function RegisterService {
    & containerd.exe --register-service
}

# Register and start service
Start-Service containerd
