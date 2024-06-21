
class WslOverrideMapping:

    declares = [
        ('/etc/wsl.conf', 'programs/wsl/wsl.conf', dict(sudo=True)),
        ('$HOME/.local/bin.linux', '$DOTMY/homebin/linux/'),
        ('$HOME/.local/bin.wsl', '$DOTMY/homebin/wsl/'),
    ]


mapping = WslOverrideMapping
