
class MyMapping:

    includes = [
        ('$DOTMY/profiles/base/wsl', 'WslOverrideMapping'),
        ('$DOTMY/profiles/base/devenv', 'DevEnvCuiMapping'),
        ('$DOTMY/profiles/base', 'LinuxLikeBaseMapping'),
    ]


mapping = MyMapping
