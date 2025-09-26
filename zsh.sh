#!/bin/bash

# Update package list and install Zsh
echo "Installing Zsh..."
if command -v zsh >/dev/null 2>&1; then
    echo "Zsh is already installed."
else
    sudo apt update
    sudo apt install -y zsh
fi

# Install Oh My Zsh (unattended)
echo "Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
else
    # Disable interactive prompts during install
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set Zsh as default shell
echo "Setting Zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

# Install zsh-autosuggestions plugin
echo "Installing zsh-autosuggestions..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed."
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting plugin
echo "Installing zsh-syntax-highlighting..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting is already installed."
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Add plugins to .zshrc if missing
echo "Configuring .zshrc plugins..."
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions)/' ~/.zshrc
fi
if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    sed -i 's/plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting)/' ~/.zshrc
fi

echo "Installation complete. Please restart your terminal or run 'exec zsh' to start using Zsh with Oh My Zsh and plugins."
