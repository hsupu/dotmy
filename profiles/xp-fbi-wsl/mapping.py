
class MyMapping:

    includes = [
        ('$DOTMY/overrides/wsl', 'WslOverrideMapping'),
        ('$DOTMY/overrides/base', 'DevEnvCuiMapping'),
        ('$DOTMY/overrides/base', 'LinuxLikeBaseMapping'),
    ]


mapping = MyMapping
