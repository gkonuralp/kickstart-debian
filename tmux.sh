#!/bin/bash

# Update package list and install tmux
sudo apt-get update
sudo apt-get install -y tmux git

# Clone Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Backup existing tmux.conf if it exists
if [ -f ~/.tmux.conf ]; then
  mv ~/.tmux.conf ~/.tmux.conf.backup
fi

# Create new tmux.conf with TPM and tmux-resurrect plugin
cat <<EOT > ~/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Initialize TPM (keep this line at the very bottom)
run '~/.tmux/plugins/tpm/tpm'
EOT

# Install the plugins using TPM
~/.tmux/plugins/tpm/bin/install_plugins

echo "Tmux and tmux-resurrect installation complete."
echo "Start tmux and press prefix + I (default prefix Ctrl-b) to ensure plugins are loaded."
