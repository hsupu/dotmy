
class LinuxCuiMapping:

    declares = [
        ('$HOME/.local/bin.linux', '$DOTMY/homebin/linux/'),
    ]

class LinuxGuiMapping:

    declares = [
        ('$HOME/.config/Code/User/', '$DOTMY/programs/vscode/keybindings.json'),
        ('$HOME/.config/Code/User/', '$DOTMY/programs/vscode/settings.json'),
    ]

class LinuxDevEnvGuiMapping:

    declares = [
        ('$HOME/.config/', '$DOTMY/programs/jetbrains/'),
    ]


mapping = LinuxCuiMapping
