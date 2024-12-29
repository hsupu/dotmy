<#
微软账号全程形如 `MicrosoftAccount\<email>`。绑定微软账号后，原本地账户会被标记为禁用，无法 RDP/SMB，需要重新激活。
注意：如果为微软账号删除了密码，那么目前无法使用 SMB，没有解决方案。
#>
param(
    [string]$User
)

& net user $User /active:yes
