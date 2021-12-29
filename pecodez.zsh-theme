# ZSH Theme File
#
# This theme displays status in coloured segments with user
# input prompt on a new line to separate content nicely
# while creating a visual "break" to the segments.
#
# Configuration allows for control over which info segments
# are rendered.


SHOW_NODE_INFO=true
SHOW_SNYK_INFO=true
SHOW_K8S_CONTEXT=true
SHOW_AWS_PROFILE=true

draw_segment() {
    print "%{$fg[$1]$BG[$2]%} $3 %{$reset_color%}"
}

user() {
    local user=$(whoami)
    print -n ":$user"
}

directory() {
    draw_segment black 245 %~
}

aws_profile() {
    [[ $SHOW_AWS_PROFILE == "true" && -n "$AWS_PROFILE" ]] && draw_segment black 208 $AWS_PROFILE
}

k8s_context() {
    [[ $SHOW_K8S_CONTEXT == "true" && -n "$ZSH_KUBECTL_CONTEXT" ]] && draw_segment white 032 $ZSH_KUBECTL_PROMPT
}

snyk_version() {
    local SNYK_BIN=$(which snyk 2> /dev/null)
    local SNYK_VERSION=$([[ -n $SNYK_BIN ]] && $SNYK_BIN -v 2> /dev/null)
    [[ $SHOW_SNYK_INFO == "true" && -n $SNYK_VERSION ]] && draw_segment white 054 "Snyk ${SNYK_VERSION}"
}

node_version() {
    local NODE_BIN=$(which node 2> /dev/null)
    local NODE_VERSION=$([[ -n $NODE_BIN ]] && $NODE_BIN -v | tr -d "v" 2> /dev/null) 
    [[ $SHOW_NODE_INFO == "true" && -n $NODE_VERSION ]] && draw_segment white 028 "Node ${NODE_VERSION}"
}

status() {
    print "$(snyk_version)$(node_version)$(aws_profile)$(k8s_context)"
}

prompt() {
    print -n "%B$(user) %(?.$fg[white].$fg[red])\u276f%{$reset_color%}%b "
}

set_prompt() {
    local nl=$'\n'
    PROMPT="$(status)$(directory)$(git_prompt_info)${nl}$(prompt)"
}


ZSH_THEME_GIT_PROMPT_ADDED="✈ "
ZSH_THEME_GIT_PROMPT_MODIFIED="✭ "
ZSH_THEME_GIT_PROMPT_DELETED="✗ "
ZSH_THEME_GIT_PROMPT_RENAMED="➦ "
ZSH_THEME_GIT_PROMPT_UNMERGED="✂ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="✱ "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$BG[240]$fg[white] \uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$BG[214]$fg[black]%} %{$(git_prompt_status)%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$bg[green]$fg[black]%} %{$reset_color%}"

autoload -Uz add-zsh-hook
add-zsh-hook precmd set_prompt

