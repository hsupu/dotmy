
class MyMapping:

    declares = [
        ('$HOME/Library/Application Support/Code/User/', 'programs/vscode/settings.json'),
    ]

    includes = [
        ('$DOTMY/overrides/mac', 'MacOverrideMapping'),
        ('$DOTMY/overrides/base', 'DevEnvCuiMapping'),
        ('$DOTMY/overrides/base', 'LinuxLikeBaseMapping'),
    ]


mapping = MyMapping
