
class WslOverrideMapping:

    declares = [
        ('/etc/', 'programs/wsl/wsl.conf', dict(sudo=True)),
        ('$HOME/.local/bin.posix', '$DOTMY/homebin/common/'),
        ('$HOME/.local/bin.wsl', '$DOTMY/homebin/wsl/'),
    ]


mapping = WslOverrideMapping
