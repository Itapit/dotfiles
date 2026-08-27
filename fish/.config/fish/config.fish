# -----------------------------------------------------
# INIT
# -----------------------------------------------------

# Disable welcome message
set -g fish_greeting ""

# Set default text editor
set -gx EDITOR nano

# Add user binary directories to PATH 
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# Source external toolchain environment (uv / local helpers)
if test -f "$HOME/.local/bin/env.fish"
    source "$HOME/.local/bin/env.fish"
end

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

alias shutdown='systemctl poweroff'


# -----------------------------------------------------
# AUTOSTART
# -----------------------------------------------------

# Oh-My-Posh prompt & Fastfetch (only run in interactive terminal sessions)
if status is-interactive
    fastfetch
    if test -f "$HOME/.local/bin/oh-my-posh"
        eval ($HOME/.local/bin/oh-my-posh init fish --config $HOME/.config/ohmyposh/zen.toml)
    end
end
