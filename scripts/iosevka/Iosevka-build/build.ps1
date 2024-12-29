<#
.NOTES
Get ttfautohint from https://sourceforge.net/projects/freetype/files/ttfautohint/
See docs from https://freetype.org/ttfautohint/doc/ttfautohint.html
#>
param()

function main {
    & pnpm install
    & pnpm run -- build ttf::IosevkaCustom
}

pushd $PSScriptRoot
try {
    main
}
finally {
    popd
}
