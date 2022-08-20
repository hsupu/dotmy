#!/usr/bin/env bash

if [[ $# < 1 ]]; then
    echo "no specified homebrew git prefix, for example: https://github.com/homebrew"
    exit -1
fi

PREFIX="$1"

cd "$(brew --repo)"
git remote set-url origin ${PREFIX}/brew.git
echo "brew.git remote-url changed."

cd "$(brew --repo)/Library/Taps/homebrew/"
for dir in $(ls -F | grep /$); do
    len=${#dir}
    formulae="${dir:0:len-1}"
    case "$formulae" in
        "homebrew-core"    | \
        "homebrew-python"  | \
        "homebrew-science" )
            cd "$dir"
            git remote set-url origin "${PREFIX}/${formulae}.git"
            echo "${formulae}.git remote-url changed."
            cd ..
            ;;
        *)
            echo "${formulae}.git skipped."
            ;;
    esac
done

echo "brew update"
brew update

