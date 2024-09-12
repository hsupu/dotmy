
# TODO use https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#list-releases-for-a-repository
if [[ -e $(which interactive-rebase-tool 2>/dev/null) ]]; then
    exit 0
fi

TAG=2.4.1
VER=$TAG

if [[ -n "$(cat /etc/os-release | grep -i ID=debian)" ]]; then
    DISTRO_VERSION_ID=$(cat /etc/os-release | grep -i VERSION_ID | cut -d= -f2 | tr -d '"')
    ARCH="debian-${DISTRO_VERSION_ID}_amd64"
    URL="https://github.com/MitMaro/git-interactive-rebase-tool/releases/download/$TAG/git-interactive-rebase-tool-$VER-$ARCH.deb"
elif [[ -n "$(cat /etc/os-release | grep -i ID=ubuntu)" ]]; then
    DISTRO_VERSION_ID=$(cat /etc/os-release | grep -i VERSION_ID | cut -d= -f2 | tr -d '"')
    ARCH="debian-${DISTRO_VERSION_ID}_amd64"
    URL="https://github.com/MitMaro/git-interactive-rebase-tool/releases/download/$TAG/git-interactive-rebase-tool-$VER-$ARCH.deb"
elif [[ -n "$(cat /etc/os-release | grep -i ID=fedora)" ]]; then
    DISTRO_VERSION_ID=$(cat /etc/os-release | grep -i VERSION_ID | cut -d= -f2 | tr -d '"')
    ARCH="fedora-${DISTRO_VERSION_ID}_amd64"
    URL="https://github.com/MitMaro/git-interactive-rebase-tool/releases/download/$TAG/git-interactive-rebase-tool-$VER-$ARCH.rpm"
else
    ARCH="alpine_amd64"
    URL="https://github.com/MitMaro/git-interactive-rebase-tool/releases/download/$TAG/git-interactive-rebase-tool-$VER-$ARCH"
fi

FILENAME=$(basename $URL)
wget -O "/tmp/$FILENAME" $URL

EXTNAME="${FILENAME##*.}"
if [[ "$EXTNAME" == "" ]]; then
    mkdir -p ~/.local/bin
    chmod +x "/tmp/$FILENAME"
    mv "/tmp/$FILENAME" ~/.local/bin/
    ln -s $FILENAME ~/.local/bin/interactive-rebase-tool
elif [[ "$EXTNAME" == "deb" ]]; then
    sudo dpkg -i "/tmp/$FILENAME"
elif [[ "$EXTNAME" == "rpm" ]]; then
    sudo rpm -i "/tmp/$FILENAME"
else
    echo "Unknown file extension: $EXTNAME"
    exit 1
fi

exit 0
