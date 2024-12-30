param(
    [Parameter(Mandatory)]
    [string]$Version,

    [string]$OutDir,

    [switch]$NoWget,
    [switch]$NoUnzip,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

if ('' -eq [string]$OutDir) {
    $OutDir = ".\out"
}

$wget = & which wget.exe
$7z = & which 7z.exe

$BaseUrl = "https://mirrors.tuna.tsinghua.edu.cn/github-release/be5invis/Sarasa-Gothic/LatestRelease/"

$base = "Sarasa"

# 非等距字体
# Gothic : 标准字型，全宽引号。
# Ui     : 专为UI界面设计的字型，半宽引号。
# 等距字体
# Mono   : 等宽字型，全宽破折号。
# Term   : 等宽字型，半宽破折号。
# Fixed  : 等宽字型，半宽破折号，无连字。
$variants = @("Fixed", "Mono", "Ui")

# 语言特征字形
# SC : 简体中文
# TC : 台湾繁体中文
# HC : 香港繁体中文
# CL : 传统旧字形
# J  : 日文
# K  : 韩文
$langs = @("SC")

$weights = @("Bold", "BoldItalic", "Italic", "Regular")

$ZipFiles = [System.Collections.Generic.List[string]]::new()

foreach ($variant in $variants) {
    foreach ($lang in $langs) {
        # foreach ($weight in $weights) {
            $ZipFiles.Add("$BaseUrl$base$variant$lang-TTF-$Version.7z")
        # }
    }
}

$ZipFiles = [System.Linq.Enumerable]::Distinct($ZipFiles)

if ($DryRun) {
    return $ZipFiles
}

if (! $NoWget) {
    & $wget -c @ZipFiles
    if (0 -ne $LASTEXITCODE) {
        throw "wget exited with code $LASTEXITCODE"
    }
}

if (! $NoUnzip) {
    foreach ($zipFile in $ZipFiles) {
        $filename = [IO.Path]::GetFileName($zipFile)
        $filePrefix = $filename.Substring(0, $filename.Length - "-TTF-$Version.7z".Length)

        $ttfs = [System.Collections.Generic.List[string]]::new()
        foreach ($weight in $weights) {
            $ttfs.Add("$filePrefix-$weight.ttf")
        }

        & $7z x $filename -o"$OutDir" @ttfs
        if (0 -ne $LASTEXITCODE) {
            throw "7z exited with code $LASTEXITCODE"
        }
    }
}
