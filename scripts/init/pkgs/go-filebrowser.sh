
# TODO use https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#list-releases-for-a-repository
if [[ -e $(which filebrowser 2>/dev/null) ]]; then
    exit 0
fi

TAG=v2.30.0
VER=${TAG#v}

$march = ''
case $(uname -m) in
    x86_64)  march="amd64" ;;
    i686)    march="386" ;;
    i386)    march="386" ;;
    aarch64) march="arm64" ;;
    armv8l)  march="arm64" ;;
    armv7l)  march="armv7" ;;
    armv6l)  march="armv6" ;;
    riscv64) march="riscv64" ;;
    *)       march="" ;;
esac

if [[ -n "$(cat /etc/os-release | grep -i GNU/Linux)" ]]; then
    filename="linux-$march-filebrowser.tar.gz"
    URL="https://github.com/filebrowser/filebrowser/releases/download/$TAG/$filename"
else
    echo "Unknown OS"
    exit 1
fi

FILENAME=$(basename $URL)
pushd /tmp
wget -O $FILENAME $URL
tar -xvf $FILENAME
mkdir -p ~/opt/filebrowser
mv ./filebrowser ~/opt/filebrowser/
popd

exit 0
