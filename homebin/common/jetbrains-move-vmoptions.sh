#!/usr/bin/env bash
# 将定制的 vmoptions 置于 /usr/local/share/custom/jetbrains/

APP=$1
VER=$2

case $APP in
	"java")
		APPNAME="IntelliJIdea"
		OPTNAME="idea.vmoptions"
		;;
	"php")
		APPNAME="PhpStorm"
		OPTNAME="phpstorm.vmoptions"
		;;
	"rb" | "ruby")
		APPNAME="RubyMine"
		OPTNAME="rubymine.vmoptions"
		;;
	"py")
		APPNAME="PyCharm"
		OPTNAME="pycharm.vmoptions"
		;;
	"go")
		APPNAME="GoLand"
		OPTNAME="goland.vmoptions"
		;;
	"js" | "web")
		APPNAME="WebStorm"
		OPTNAME="webstorm.vmoptions"
		;;
	"c")
		APPNAME="CLion"
		OPTNAME="clion.vmoptions"
		;;
esac

function move_and_link() {
	SRC=$1
	DST=$2
	if [[ -f "$SRC" ]]; then
	    #mv "$SRC" "$DST"
		#echo "$SRC moved"
		rm "$SRC"
		echo "$SRC removed"
	fi
	ln -sf "$DST" "$SRC"
}

move_and_link \
	"${HOME}/Library/Application Support/JetBrains/${APPNAME}${VER}/${OPTNAME}" \
	"/usr/local/share/custom/jetbrains/${OPTNAME}"

