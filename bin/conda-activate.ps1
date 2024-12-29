param(
    [string]$EnvName = "base"
)

$candidates = @(
    "C:\opt2\anaconda3",
    "C:\opt\anaconda3",
    "$HOME\anaconda3"
)

$CONDA_ROOT = $null
foreach ($candidate in $candidates) {
    $path = Join-Path $candidate "condabin\conda.bat"
    if (Test-Path $path) {
        $CONDA_ROOT = $candidate
        break
    }
}
if (-not $CONDA_ROOT) {
    throw "conda not found"
}

& "${CONDA_ROOT}\shell\condabin\conda-hook.ps1"

if ($EnvName -ieq "base") {
    $EnvPath = "${CONDA_ROOT}"
}
else {
    $EnvPath = "${CONDA_ROOT}\envs\$EnvName"
    if (-not (Test-Path $EnvPath)) {
        throw "Environment not found: $EnvName"
    }
}
& conda activate $EnvPath
