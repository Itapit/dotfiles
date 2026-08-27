# -----------------------------------------------------
# INIT & ENVIRONMENT
# -----------------------------------------------------

# Set default text editor
export EDITOR=nano

# Add user binary directories to PATH 
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Source external toolchain environment (uv / local helpers) if present
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

alias shutdown='systemctl poweroff'

# -----------------------------------------------------
# INTERACTIVE & PROMPT SETUP
# -----------------------------------------------------

# Run only in interactive terminal sessions
case $- in
    *i*) ;;
      *) return;;
esac

# System info banner (only on pseudo-terminals)
if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi

# Oh-My-Posh prompt initialization
if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init bash --config "$HOME/.config/ohmyposh/EDM115-newline.omp.json")"
fi