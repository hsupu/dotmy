
unset enable_nvm
function enable_nvm() {
    if [[ -z $NVM_DIR ]]; then
        echo "\$NVM_DIR not set"
        return
    fi
    safe_source "/usr/local/opt/nvm/nvm.sh"
    safe_source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
}

function docker_env() {
    eval "$(docker-machine env $*)"
}

function set_app_language() {
    LANGUAGE="(\"$1\")"
    echo ${LANGUAGE}
    return 0
    defaults write com.brunophilipe.Cakebrew AppleLanguages ${LANGUAGE}
}

function zshextra() {
    # load plugins
    plugins=(colorize colored-man-pages tmux)

    is_plugin() {
        local base_dir=$1
        local name=$2
        test -f $base_dir/plugins/$name/$name.plugin.zsh \
        || test -f $base_dir/plugins/$name/_$name
    }

    for plugin ($plugins); do
        if is_plugin $ZSH_CUSTOM $plugin; then
            fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
        elif is_plugin $ZSH $plugin; then
            fpath=($ZSH/plugins/$plugin $fpath)
        fi
    done

    for plugin ($plugins); do
        if [ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]; then
             source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
        elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
             source $ZSH/plugins/$plugin/$plugin.plugin.zsh
        fi
    done
}

true
