
class LinuxCuiMapping:

    declares = [
        ('$HOME/.local/bin.linux', '$DOTMY/homebin/linux/'),
        ('$HOME/.local/bin.posix', '$DOTMY/homebin/common/'),
    ]


class LinuxGuiMapping:

    declares = [
        ('$HOME/.config/Code/User/', 'programs/vscode/keybindings.json'),
        ('$HOME/.config/Code/User/', 'programs/vscode/settings.json'),
    ]


class LinuxDevEnvGuiMapping:

    declares = [
        ('$HOME/.config/', '$DOTMY/programs/jetbrains/'),
    ]


mapping = LinuxCuiMapping
