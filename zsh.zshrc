export EDITOR=vim
export BROWSER=google-chrome-stable
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="kolo"
ZSH_THEME="theunraveler"
ZSH_THEME="gallois"
ZSH_THEME="sorin"
ZSH_THEME="muse"

plugins=()

# Keep Oh My Zsh's Git prompt working when it is called through the jj fallback.
zstyle ':omz:alpha:lib:git' async-prompt force

source $ZSH/oh-my-zsh.sh

g() { git $@; }
gA() { git add $@; }
gC() { git commit --all $@; }
gD() { git diff --cached $@; }
gG() { git log $@; }
gO() { git checkout $@; }
gR() { git rebase --interactive $@; }
gS() { gh pr view --web $@; }
gW() { git commit --amend $@; }
ga() { git add --all $@; }
gb() { git checkout -b $@; }
gbd() { git branch -D $@; }
gc() { git commit --all --amend --no-edit $@; }
gd() { git diff $@; }
gdet() { git checkout --detach HEAD; }
ge() { git restore --staged $@; }
gg() { git status $@; }
gl() { git fetch --all && git branch -f main origin/main; }
gn() { git next --interactive $@; }
go() { git checkout main $@; }
gp() { git prev --interactive $@; }
gr() { git rebase main; }
gri() { git rebase -i $@; }
gra() { git rebase --abort; }
grc() { git rebase --continue; }
gs() { git push --force-with-lease --set-upstream $@; }
gw() { git sw --interactive $@; }

j() { jj status "$@"; }
jw() { jj describe "$@"; }
jn() { jj new "$@"; }
ja() { jj arrange "$@"; }
je() { jj edit "$@"; }
jd() { jj diff "$@"; }
jD() { jj diff --revision @- "$@"; }
jG() { jj log "$@"; }
jGG() { jj log -T builtin_log_compact_full_description "$@"; }
jb() { jj bookmark create "$@"; }
jl() { jj git fetch --all-remotes "$@" && jj bookmark set main --revision main@origin --allow-backwards; }
jo() { jj edit main "$@"; }
jr() { jj rebase --destination main; }
jq() { jj squash "$@"; }
js() { jj git push "$@"; }
jN() { jj next --edit "$@"; }
jP() { jj prev --edit "$@"; }

# Prefer jj's state in jj workspaces, including colocated workspaces. Fall
# back to the existing Oh My Zsh Git prompt elsewhere.
function jj_or_git_prompt() {
  if command jj root > /dev/null 2>&1; then
    local anchor_info anchor anchor_commit distance info jj_state

    anchor_info=$(command jj --no-pager log --no-graph \
      -r 'heads(::@ & bookmarks())' \
      -T 'self.local_bookmarks().join(", ") ++ "\t" ++ self.commit_id()' \
      2> /dev/null) || return
    anchor_info=${anchor_info%%$'\n'*}
    anchor=${anchor_info%%$'\t'*}
    anchor_commit=${anchor_info#*$'\t'}

    if [[ -n "$anchor" && "$anchor_commit" != "$anchor_info" ]]; then
      distance=$(command jj --no-pager log --no-graph -r "$anchor_commit..@" \
        -T 'self.change_id() ++ "\n"' 2> /dev/null | sort -u | wc -l)
      info="$anchor"
      [[ "$distance" -gt 0 ]] && info+=" +$distance"
    else
      info=$(command jj --no-pager log --no-graph -r @ \
        -T 'self.commit_id().shortest(8)' 2> /dev/null) || return
    fi

    jj_state=$(command jj --no-pager log --no-graph -r @ -T \
      'if(self.conflict(), "⊥", if(self.divergent(), "≠", if(self.empty(), "Ø", "∗")))' \
      2> /dev/null) || return
    info="$info $jj_state"
    info="${info:gs/%/%%}"
    printf '%s%s%s' "$ZSH_THEME_GIT_PROMPT_PREFIX" "$info" "$ZSH_THEME_GIT_PROMPT_SUFFIX"
  else
    git_prompt_info
    git_prompt_status
  fi
}

PROMPT="${FG[117]}%~%{$reset_color%}\$(jj_or_git_prompt)\$(virtualenv_prompt_info) ${FG[077]}ᐅ%{$reset_color%} "

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle :compinstall filename "/$HOME/.zshrc"

autoload -Uz compinit
compinit

unsetopt share_history

eval "$(devenv hook zsh)"
export PATH="$HOME/.local/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/home/geecko/.local/bin:$PATH"
