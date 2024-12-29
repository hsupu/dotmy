param(
    [string]$Path
)

$file = Get-Item -LiteralPath $Path

# https://learn.microsoft.com/en-us/windows/win32/fileio/file-attribute-constants
[Flags()] enum MyFileAttributes {
    Readonly =              0x00000001
    Hidden =                0x00000002
    System =                0x00000004
    Directory =             0x00000010
    Archive =               0x00000020
    # for system use
    Device =                0x00000040
    Normal =                0x00000080
    # TODO
    Temporary =             0x00000100
    SparseFile =            0x00000200
    ReparsePoint =          0x00000400
    Compressed =            0x00000800
    # 文件内容不在本地
    Offline =               0x00001000
    NotContentIndexed =     0x00002000
    # 标志着文件已加密，或是目录下新文件默认要加密
    Encrypted =             0x00004000
    # for ReFS
    IntegrityStream =       0x00008000
    # for system use
    Virtual =               0x00010000
    NoScrubData =           0x00020000
    # 标志着文件/目录有拓展属性
    ExtendedAttributes =    0x00040000
    # 标志着文件/目录应该一直保持在本地，即使没有活跃访问
    Pinned =                0x00080000
    # 标志着文件/目录应该不保持在本地，除非有活跃访问
    Unpinned =              0x00100000
    # 标志着文件/目录不在本地
    # 仅当枚举目录时出现（）
    RecallOnOpen =          0x00040000
    # 标志着文件/目录并非全在本地
    # 只有内核态可以设置
    RecallOnDataAccess =    0x00400000
}
$attrs = [System.Enum]::GetValues[MyFileAttributes]()
$original = [MyFileAttributes]$file.Attributes

# $attrs = [System.Enum]::GetValues[System.IO.FileAttributes]()
# $original = [System.IO.FileAttributes]$file.Attributes

$wellknown = 0
foreach ($attr in $attrs) {
    if ($original.HasFlag($attr)) {
        $wellknown += $attr
        Write-Host "0x$('{0:x}' -f $attr) $attr"
    }
}
$unknown = $original - $wellknown

Write-Host "-"
Write-Host "0x$('{0:x}' -f $original) Attributes"
if (0 -ne $unknown) {
    Write-Host "0x$('{0:x}' -f $unknown) Unknown"
}
