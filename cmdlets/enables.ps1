
function Enable-Pyenv()
{
    $root = $(scoop prefix pyenv)
    if ($LASTEXITCODE -ne 0) {
        return $LASTEXITCODE
    }
    [System.Environment]::SetEnvironmentVariable("Path", "$root\pyenv-win\shims;" + $env:Path, "Process")
}

function Enable-Nvm()
{
    $root = $(scoop prefix nvm)
    if ($LASTEXITCODE -ne 0) {
        return $LASTEXITCODE
    }
    $env:NVM_HOME = $root
    $env:NVM_SYMLINK = "$root\nodejs\nodejs"
    [System.Environment]::SetEnvironmentVariable("Path", "${env:NVM_SYMLINK};" + $env:Path, "Process")
}
