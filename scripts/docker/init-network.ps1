

function
New-ContainerTransparentNetwork
{
    # Check if transparent network already created
    $networkList = docker network ls 
    if ($networkList -match '\bTransparent\b')
    {
        Write-Output "Network with the name Transparent exists."
        return
    }
 
    # Continue with network creation
    if ($ExternalNetAdapter)
    {
        $netAdapter = (Get-NetAdapter |? {$_.Name -eq "$ExternalNetAdapter"})[0]
    }
    else
    {
        $netAdapter = (Get-NetAdapter |? {($_.Status -eq 'Up') -and ($_.ConnectorPresent)})[0]
    }

    Write-Output "Creating container network (Transparent)..."
    docker network create -d transparent -o com.docker.network.windowsshim.interface="$($netAdapter.Name)" "Transparent"
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create transparent network."
    }

    # Transparent networks are not picked up by docker until after a service restart.
    if (Test-Docker)
    {
        Restart-Service -Name $global:DockerServiceName
        Wait-Docker
    }
}
