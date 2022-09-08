# https://github.com/junegunn/fzf/
#
try {
    if ($null -eq (Get-Command fzf)) {
        throw
    }
}
catch {
    Write-Information "fzf not found"
    return
}

# https://sift-tool.org/
#
# &{
#     try {
#         if ($null -eq (Get-Command sift)) {
#             throw
#         }
#     }
#     catch {
#         Write-Information "sift not found"
#         return
#     }
#
#     $env:FZF_DEFAULT_COMMAND = "sift --targets . 2> nul"
# }

# https://github.com/BurntSushi/ripgrep
#
&{
    try {
        if ($null -eq (Get-Command rg)) {
            throw
        }
    }
    catch {
        Write-Information "ripgrep not found"
        return
    }

    $env:FZF_DEFAULT_COMMAND = "rg --files . 2> nul"
}

# https://github.com/kelleyma49/PSFzf
