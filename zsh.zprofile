export PATH=$HOME/bin/scripts:$HOME/bin/shortcuts:$PATH
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/openssh_agent

systemctl --user start ssh-agent
