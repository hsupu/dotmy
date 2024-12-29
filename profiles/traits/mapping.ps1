
# base
#

# suffix '/' matters
$base_mapping = @(
    @('$HOME/.config/git/attributes', '$($env:DOTMY)/programs/git/attributes'),
    @('$HOME/.config/navi', '$($env:DOTMY)/programs/navi/'),
    @('$HOME/.config/wezterm', '$($env:DOTMY)/programs/wezterm/'),
    @('$HOME/.local', 'C:/my/local/'),
    @('$HOME/.ssh', '$($env:DOTMY)/private/current/ssh/'),
    @('C:/my/bin', '$($env:DOTMY)/bin/'),
    @("$($env:SystemRoot)\WindowsPowerShell", "$($env:SystemRoot)\System32\WindowsPowerShell\", @{ sudo=$true }),
    @()
)

$base_userenv = @{
    'DOTMY' = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..');
    'SCOOP' = 'C:/opt/scoop';
}

# optional
#

# suffix '/' matters
$optional_mapping = @(
    @('$HOME/.config/winfetch', '$($env:DOTMY)/programs/winfetch/'),
    @()
)

# devenv
#

# suffix '/' matters
$devenv_mapping = @(
    @('$($env:APPDATA)/pip/pip.ini', '$($env:DOTMY)/programs/python/pip.conf'),
    # @('$($env:ProgramData)/docker/config/', '$($env:DOTMY)/programs/docker/daemon.json', @{ sudo=$true }),
    @('$($env:ProgramData)/docker/config/', '$($env:DOTMY)/programs/docker/daemon.json', @{ sudo=$true }), # since 27.1
    @('$HOME/.config/alacritty', '$($env:DOTMY)/programs/alacritty/'),
    @('$HOME/.config/conda', '$($env:DOTMY)/programs/anaconda/'),
    @('$HOME/.m2/settings.xml', '$($env:DOTMY)/programs/apache-maven/m2-settings.xml'),
    @('$HOME/.npmrc', '$($env:DOTMY)/programs/nodejs/npmrc'), # npm doesn't support an alternative position, till 220331
    @('$HOME/.pypirc', '$($env:DOTMY)/programs/python/pypirc'),
    # @('$HOME/Documents/Visual Studio 2022', '$($env:DOTMY)/programs/vs/'),
    @()
)

$devenv_userenv = @{
    'CARGO_HOME' = 'C:\opt\cargo';
    'RUSTUP_HOME' = 'C:\opt\rustup';

    'DOTENT_CLI_TELEMETRY_OPTOUT' = 1;

    # 'GIT_INSTALL_ROOT' = (& scoop prefix git); # 自动配置

    'GO111MODULE' = 'on';

    'JAVA_TOOL_OPTIONS' = '-Duser.language=en -Dfile.encoding=UTF8';

    # 'NODE_PATH' = '$($env:SCOOP)\persist\nvm\nodejs\nodejs'; # 自动配置
    'NPM_CHECK_INSTALLER' = 'pnpm';
    # 'NVM_HOME' = (& scoop prefix nvm); # 自动配置
    # 'NVM_SYMLINK' = '$($env:SCOOP)\persist\nvm\nodejs\nodejs'; # 自动配置

    # 'PNPM_HOME' = '($env:LOCALAPPDATA)\pnpm'; # 自动配置
    # 'PYENV' = (Join-Path (& scoop prefix pyenv) 'pyenv-win'); # 自动配置
    # 'PYENV_HOME' = (Join-Path (& scoop prefix pyenv) 'pyenv-win'); # 已弃用？
    # 'PYENV_ROOT' = (Join-Path (& scoop prefix pyenv) 'pyenv-win'); # 已弃用？
    # 'PYTHON_BUILD_MIRROR_URL' = 'https://registry.npmmirror.com/-/binary/python';
    # 'PYTHON_BUILD_MIRROR_URL' = ‘https://mirrors.aliyun.com/python-release/‘;
    'PYTHON_BUILD_MIRROR_URL' = 'https://jedore.netlify.app/tools/python-mirrors/';
    # 'PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM' = 1;

    'VCPKG_DISABLE_METRICS' = 1;
    'VCPKG_ROOT' = 'C:\opt\vcpkg';
}

# wsl
#

# suffix '/' matters
$wsl_mapping = @(
    @('$HOME/.wslconfig', 'programs/wsl/wslconfig'),
    @()
)

$includes = @(
    '.:base'
)
