
class DevEnvCuiMapping:

    declares = [
        # python
        ('$HOME/.config/pip/', '$DOTMY/programs/python/pip.conf'),
        ('$HOME/.config/pip/', '$DOTMY/programs/python/requirements.txt'),
        # ('$HOME/.invoke.yaml', 'programs/python/invoke.yaml'),
        # java
        ('$HOME/.m2/settings.xml', '$DOTMY/programs/java/m2.settings.xml'),
        # ('$HOME/.sbt/repositories', '$DOTMY/programs/java/sbt-repositories'),
        # nodejs
        ('$HOME/.npmrc', '$DOTMY/programs/nodejs/npmrc'),
        ('$HOME/.yarnrc', '$DOTMY/programs/nodejs/yarnrc', dict(copy=True)),
        # ruby
        # ('$HOME/.gemrc', '$DOTMY/programs/ruby/gemrc'),
        # ('$HOME/.bundle/config', '$DOTMY/programs/ruby/bundle_config'),
        # php
        # ('$HOME/.composer/', '$DOTMY/programs/composer/config.json'),
    ]


mapping = DevEnvCuiMapping
