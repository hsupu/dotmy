
class MacOverrideMapping:

    declares = [
        ('$HOME/.config/aria2/', 'programs/aria2/aria2.conf'),
        ('$HOME/.config/pip/requirements.txt', 'programs/python/requirements.txt'),
        ('$HOME/.config/tmux/', 'programs/tmux/tmux.conf'),
        ('$HOME/.local/bin.mac', '$DOTMY/homebin/wsl/'),
        ('$HOME/Library/Application Support/Code/User/', 'programs/vscode/keybindings.json'),
    ]


mapping = MacOverrideMapping
