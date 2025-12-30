# Neovim mapping
alias vi='nvim'
alias vim='nvim'
alias VI='nvim'
alias VIM='nvim'
alias theinvincibleeditor='nvim'

### runs fastfetch
alias ff='fastfetch'
### Trying to get an alias for history pip fzf - strip the leading number to pbcopy
alias hpf='history | fzf | sed "s/^[^a-zA-Z]*//" | tr -d "\n" | pbcopy'

### Aliases and functions
alias lf='eza  --only-files --color=always --color-scale=all --color-scale-mode=gradient --icons=always'
#alias ls='eza -aF --group-directories-first'
alias ll='eza -al --group-directories-first'
alias lt='eza -al --sort=modified'
alias ld='eza -LD'
alias lh='eza -a -ld .*'
alias l='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first'
alias ll='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -l --git -h'
alias la='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a'
alias lla='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a -l --git -h'
