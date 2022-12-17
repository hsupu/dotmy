tmux has -t main || {
  tmux new -d -t main
  tmux new-window -t main /as/scripts/redir.sh -u
  #tmux new-window -t main /as/scripts/dns.sh
}

exit 0
