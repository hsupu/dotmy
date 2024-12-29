param(
    [Int16]$Port
)

& netstat -ano | findstr $Port
