
class MyMapping:

    declares = [
        ('$HOME/Library/Application Support/Code/User/', 'programs/vscode/settings.json'),
    ]

    includes = [
        ('$DOTMY/profiles/base/mac', 'MacOverrideMapping'),
        ('$DOTMY/profiles/base/devenv', 'DevEnvCuiMapping'),
        ('$DOTMY/profiles/base', 'LinuxLikeBaseMapping'),
    ]


mapping = MyMapping
