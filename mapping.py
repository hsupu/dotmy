
mapping = {
    'programs/aria2/aria2.conf': '$HOME/.config/aria2/',
    'programs/composer/config.json': '$HOME/.composer/',
    'programs/git/attributes': '$HOME/.config/git/',
    'programs/git/ignore': '$HOME/.config/git/',
    'programs/java/m2.settings.xml': '$HOME/.m2/settings.xml',
    'programs/java/sbt-repositories': '$HOME/.sbt/repositories',
    'programs/jetbrains/': '$HOME/.config/',
    'programs/nodejs/npmrc': '$HOME/.npmrc',
    # 'programs/python/invoke.yaml': '$HOME/.invoke.yaml',
    'programs/python/pip.conf': '$HOME/.config/pip/',
    'programs/python/requirements.txt': '$HOME/.config/pip/',
    'programs/ruby/bundle_config': '$HOME/.bundle/config',
    'programs/ruby/gemrc': '$HOME/.gemrc',
    'programs/tmux/tmux.conf': '$HOME/.config/tmux/',
    'programs/tsocks/tsocks.conf': '/etc/',
}

copy = {
    'programs/git/config': '$HOME/.config/git/',
    'programs/nodejs/yarnrc': '$HOME/.yarnrc',
}

wsl_mapping = {
    'programs/wsl/wsl.conf': '/etc/wsl.conf',
}
