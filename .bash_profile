source /Users/myho/.profile

#=======================================================================
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:/Users/myho/bin/sdk/platform-tools:$PATH"

#=======================================================================
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#=======================================================================
bash_prompt() {
   local status=$(git status 2> /dev/null | grep 'working directory clean')
   local dirty=''
   if [ -z "$status" ]; then
        local dirty='*'
   fi
   local branch=$(git branch 2> /dev/null | grep -e "\* " | sed "s/^..\(.*\)/\1/")

   local GREEN="\[\033[32m\]"
   local YELLOW="\[\033[33m\]"
   local CYAN="\[\033[36m\]"
   local DEFAULT="\[\033[39m\]"

   local BASE_PROMPT="$(date +%H:%M) \u@$YELLOW\h$DEFAULT:\w"
   if [ -z "$branch" ]; then
        export PS1="[$BASE_PROMPT] "
   else
        export PS1="[$BASE_PROMPT $GREEN$branch$CYAN$dirty$DEFAULT] "
   fi

   #list current directory relative to home directory
   echo -ne "\033]0;${PWD/#$HOME/}\007"
}

#=======================================================================
function git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=42
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=43
        else
            local ansi=45
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -ne '\[\e[0;37;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '

    fi
}

function prompt_command() {
    PS1="`git_prompt`"'\[\e[1;34m\]\w \$\[\e[0m\] '
}

#=======================================================================
PROMPT_COMMAND=prompt_command
# PROMPT_COMMAND=bash_prompt

#========================GIT ALIASES===============================================
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gf='git fetch --all'
alias go='git checkout'
alias gob='git checkout -b'
alias gp='git push'
alias gr='git rebase'
alias gs='git status'
alias gx='gitx'

alias gpuppet='git fetch --all && git rebase && git push origin master'

#========================GIT COMPLETION [brew install bash-completion git-extras]===============================================
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# auto completion does not work with bash alias, so have to do this hack
__git_complete go _git_checkout
__git_complete gp _git_push
__git_complete ga _git_add
__git_complete gd _git_diff
__git_complete gr _git_rebase

#===============NAME TERMINAL TAB========================================================
function name {
    echo -ne "\033]0;"$*"\007"
}

#===============OPEN INTELLIJ IN TERMINAL========================================================
ij () {
    open -b com.jetbrains.intellij "$@"
}

#=======================================================================

HISTFILESIZE=2500

#===============SHOW/HIDE hidden files========================================================

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias es=elasticsearch

elasticsearch() {
  /usr/local/share/elasticsearch/bin/service/elasticsearch $1
}
#================================= SCALA ======================================
export SCALA_HOME=/usr/local/opt/scala/idea


