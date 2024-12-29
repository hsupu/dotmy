
function global:Enable-Pyenv {
    $root = & scoop prefix pyenv
    if ($LASTEXITCODE -ne 0) {
        return $LASTEXITCODE
    }
    # [System.Environment]::SetEnvironmentVariable("Path", $env:PATH, "Process")
    $env:PATH = [string]::Join([IO.Path]::PathSeparator, @("$root\pyenv-win\shims", $env:PATH))
}

function global:Enable-Nvm {
    $root = & scoop prefix nvm
    if ($LASTEXITCODE -ne 0) {
        return $LASTEXITCODE
    }
    $env:NVM_HOME = $root
    $env:NVM_SYMLINK = "$root\nodejs\nodejs"
    $env:PATH = [string]::Join([IO.Path]::PathSeparator, @($env:NVM_SYMLINK, $env:PATH))
}
