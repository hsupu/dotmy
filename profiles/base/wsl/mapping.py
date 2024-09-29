
class WslOverrideMapping:

    declares = [
        ('/etc/wsl.conf', 'programs/wsl/wsl.conf', dict(sudo=True)),
        ('$HOME/.local/bin.posix', '$DOTMY/homebin/common/'),
        ('$HOME/.local/bin.wsl', '$DOTMY/homebin/wsl/'),
    ]


mapping = WslOverrideMapping
