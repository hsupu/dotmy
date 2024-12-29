param(
    [string]$ZipFile,
    [string]$OutDir,
    [switch]$DryRun
)

if ('' -eq [string]$ZipFile) {
    $ZipFile = Get-Item "Sarasa-TTF-*.7z" | Select-Object -First 1
}

if ('' -eq [string]$OutDir) {
    $OutDir = ".\out"
}

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

$files = [System.Collections.Generic.List[string]]::new()

foreach ($variant in $variants) {
    foreach ($lang in $langs) {
        foreach ($weight in $weights) {
            $files.Add("$base$variant$lang-$weight.ttf")
        }
    }
}

if ($DryRun) {
    return $files
}

& 7z x $ZipFile -o"$OutDir" @files
