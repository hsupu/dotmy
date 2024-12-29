
@"
branch
sha: git rev-parse --abbrev-ref HEAD
head: git rev-parse --abbrev-ref HEAD
root: git rev-parse --show-toplevel
sync: git fetch -p origin
bind: git branch --set-upstream origin/`$(git rev-parse --abbrev-ref HEAD)
unbind: git branch -rd origin/<branch>
push: git push origin `$(git rev-parse --abbrev-ref HEAD)
amend: git commit --amend --no-edit
reset-author: git rebase --root --exec `"git commit --amend --no-edit --reset-author`"
orphan: git switch --orphan <new-branch>

file
case-sensitive: git mv -f <origcase> <NewCase>
"@
