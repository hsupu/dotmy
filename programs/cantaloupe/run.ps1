
function main {
    $env:JAVA_TOOL_OPTIONS = "-Duser.language=en -Dfile.encoding=UTF8"

    $javaOpts = @(
        "-Dcantaloupe.config=.\cantaloupe.properties",
        "-Xmx2g"
    )
    $jar = Resolve-Path "dist\cantaloupe-5.0.5.jar"
    $cmdArgs = @()

    & java @javaOpts -jar $jar @cmdArgs
    if (0 -ne $LASTEXITCODE) {
        throw "java exited with code $LASTEXITCODE"
    }
}

Push-Location
try {
    main
}
finally {
    Pop-Location
}
