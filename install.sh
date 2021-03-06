#!/bin/bash
CURRENT_DIR="$(pwd)"
if [ "$(uname)" == "Darwin" ]; then
	echo "Mac detected"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install httpie \
		neovim \
		python3 \
		tmux \
		wget \
		fpp \
		zsh-history-substring-search
	brew tap homebrew/cask-fonts
	brew cask install font-iosevka-nerd-font karabiner-elements
	echo "You'll need to edit karabiner-elements to allow capslock to handle esc/ctrl"
elif [ -f "/etc/arch-release" ]; then
	sudo pacman -S neovim tmux zsh xclip 
    echo "bind -t vi-copy y copy-pipe \"xclip -sel clip -i\"" >> tmux.conf
	echo "alias pbcopy='xclip -selection clipboard'" >> zshrc
	echo "alias pbpaste='xclip -selection clipboard -o'" >> zshrc
else
   	sudo add-apt-repository ppa:neovim-ppa/stable -y
	sudo apt update -y
	sudo apt-get install -y zsh tmux neovim python3 python3-neovim neovim xclip
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	curl https://sh.rustup.rs -sSf | sh
	$HOME/.cargo/bin/cargo install exa
	echo "bind -t vi-copy y copy-pipe \"xclip -sel clip -i\"" >> tmux.conf
	echo "alias pbcopy='xclip -selection clipboard'" >> zshrc
	echo "alias pbpaste='xclip -selection clipboard -o'" >> zshrc
fi
pip install --user neovim pynvim
mkdir -p "$HOME/.cache/zsh/"
mkdir -p "$HOME/.local/share/nvim/plugged"
mkdir -p "$HOME/.config/nvim/undo"
mkdir -p "$HOME/.config/nvim/colors/"

curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
ln -s "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
git clone https://github.com/jimeh/tmux-themepack.git "$HOME/.tmux-themepack" && cd "$HOME/.tmux-themepack" && git checkout add-prefix-key-and-pane-sync-indicators && cd - 
cp "$CURRENT_DIR/zshrc" "$HOME/.zshrc"
cp "$CURRENT_DIR/init.vim" "$HOME/.config/nvim/"
cp "$CURRENT_DIR/gitconfig" "$HOME/.gitconfig"
cp "$CURRENT_DIR/tmux.conf" "$HOME/.tmux.conf"
cp "$CURRENT_DIR/compinit-oh-my-zsh.zsh" "$HOME/.oh-my-zsh/custom/compinit-oh-my-zsh.zsh"
cp "$CURRENT_DIR/vibrantink.vim" "$HOME/.config/nvim/colors/"
nvim +PlugInstall +UpdateRemotePlugins +qa
