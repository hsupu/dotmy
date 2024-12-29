param(
    [int]$Level = 0
)

# Ring0 - essential
#
if ($Level -lt 0) { return }

# Ring1 - basic
#
if ($Level -lt 1) { return }

# WinServer 默认不安装办公套件
& winget install --source winget Microsoft.OneDrive

# Ring2 - advanced
#
if ($Level -lt 2) { return }

# WinServer 默认不安装办公套件
& winget install --source winget Microsoft.Office

# Ring3 - optional
#
if ($Level -lt 3) { return }
