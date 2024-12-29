param(
    [string]$Path
)

$Path = Resolve-Path -ErrorAction Stop $Path

# -l : show fingerprint
& ssh-keygen -l -E sha256 -f $Path
& ssh-keygen -l -E md5 -f $Path

# & openssl pkey -in $Path -pubout -outform DER | openssl md5 -c
# & openssl pkey -in "$($Path).pub" -pubin -pubout -outform DER | openssl md5 -c
