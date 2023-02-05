
mapping = {
    'aria2/': '$HOME/.config/aria2/',
    'composer-config.json': '$HOME/.composer/config.json',
    'git/ignore': '$HOME/.config/git/ignore',
    'java/m2.settings.xml': '$HOME/.m2/settings.xml',
    'java/sbt-repositories': '$HOME/.sbt/repositories',
    'nodejs/npmrc': '$HOME/.npmrc',
    'nodejs/yarnrc': '$HOME/.yarnrc',
    'python/invoke.yaml': '$HOME/.invoke.yaml',
    'python/pip.conf': '$HOME/.config/pip/pip.conf',
    'python/requirements.txt': '$HOME/.config/pip/requirements.txt',
    'ruby/bundle_config': '$HOME/.bundle/config',
    'ruby/gemrc': '$HOME/.gemrc',
    'tmux/tmux.conf': '$HOME/.config/tmux/tmux.conf',
    'tsocks/tsocks.conf': '/etc/tsocks.conf',
    'wsl/wsl.conf': '/etc/wsl.conf',
}

copy = {
    'git/config': '$HOME/.config/git/config',
    'nodejs/yarnrc': '$HOME/.yarnrc',
}

mac_overrides = {
    'aria2/aria2-mac.conf': '$HOME/.config/aria2/aria2.conf',
    'jetbrains/': '/usr/local/share/custom/jetbrains',
    'python/requirements-mac.txt': '$HOME/.config/pip/requirements.txt',
    'vscode/mac/keybindings.json': '$HOME/Library/Application Support/Code/User/',
    'vscode/mac/settings.json': '$HOME/Library/Application Support/Code/User/',
}

linux_overrides = {
    'vscode/linux/': '$HOME/.config/Code/User/',
}

overrides = {
    'mac': mac_overrides,
    'linux': linux_overrides,
}
