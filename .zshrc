# Show the username and host at the prompt
PROMPT='%n@%m %~ %# '

# Add color to my zshrc
autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# Add the zsh alias file
source ~/.zsh_alias

# Add Brew to the path
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Add Krew for Kubectl
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"