
class LinuxLikeBaseMapping:

    declares = [
        ('/etc/', '$DOTMY/programs/tsocks/tsocks.conf', dict(sudo=True)),
        ('$HOME/.config/git/', '$DOTMY/programs/git/attributes'),
        ('$HOME/.config/git/', '$DOTMY/programs/git/config', dict(copy=True)),
        ('$HOME/.config/git/', '$DOTMY/programs/git/ignore'),
        ('$HOME/.config/tmux/', '$DOTMY/programs/tmux/tmux.conf'),
    ]


mapping = LinuxLikeBaseMapping
