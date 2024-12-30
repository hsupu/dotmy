<#
.NOTES
Get ttfautohint from https://sourceforge.net/projects/freetype/files/ttfautohint/
See docs from https://freetype.org/ttfautohint/doc/ttfautohint.html
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

function main {
    & pnpm install
    if (0 -ne $LASTEXITCODE) {
        throw "pnpm install exited with code $LASTEXITCODE"
    }

    # & pnpm run -- build ttf::IosevkaCustom
    & pnpm run -- build super-ttc::IosevkaPu
    if (0 -ne $LASTEXITCODE) {
        throw "pnpm run exited with code $LASTEXITCODE"
    }
}

pushd $PSScriptRoot
try {
    main
}
finally {
    popd
}
