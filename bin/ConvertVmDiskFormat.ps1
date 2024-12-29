param(
    [Parameter(Mandatory, Position=0)]
    [string]$Src,

    [Parameter(Mandatory, Position=1)]
    [string]$Dst,

    [switch]$DryRun
)

$srcItem = Get-Item -LiteralPath $Src

$srcExt = $srcItem.Extension.Substring(1)
$dstExt = [IO.Path]::GetExtension($Dst).Substring(1)

& qemu-img.exe convert -f $srcExt -O $dstExt $srcItem.FullName $Dst

# VBoxManage.exe clonehd source.vmdk target.vdi --format VDI
# VBoxManage.exe clonehd source.vdi target.vmdk --format VMDK
# VBoxManage.exe clonehd source.vdi target.vhd --format VHD
