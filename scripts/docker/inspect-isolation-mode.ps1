<#
.LINK
https://learn.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility?tabs=windows-server-2022%2Cwindows-11#mitigation---use-hyper-v-isolation-with-docker-swarm
#>
param(
    [Parameter(Mandatory)]
    [string]$InstanceNameOrId
)

& docker inspect --format='{{json .HostConfig.Isolation}}' $InstanceNameOrId
