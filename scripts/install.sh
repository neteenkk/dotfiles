#!/bin/bash
# ============================================================================
# ZSH Setup Installation Script
# Installs all dependencies for the beautiful ZSH configuration
# ============================================================================

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     ZSH Ultimate Setup - Installation Script                  ║"
echo "║     Installing all dependencies and modern CLI tools          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    PKG_MANAGER="brew"
fi

echo -e "${BLUE}Detected OS: ${OS} with package manager: ${PKG_MANAGER}${NC}\n"

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[→]${NC} $1"
}

# ============================================================================
# 1. Install ZSH if not present
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 1: Installing ZSH${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if ! command -v zsh &> /dev/null; then
    print_info "ZSH not found. Installing..."
    case $PKG_MANAGER in
        apt)
            sudo apt-get update && sudo apt-get install -y zsh
            ;;
        yum)
            sudo yum install -y zsh
            ;;
        pacman)
            sudo pacman -S --noconfirm zsh
            ;;
        brew)
            brew install zsh
            ;;
    esac
    print_status "ZSH installed"
else
    print_status "ZSH already installed"
fi


# ============================================================================
# 2. Install Modern CLI Tools
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 3: Installing Modern CLI Tools${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Function to install a package
install_package() {
    local package=$1
    local name=$2
    
    if ! command -v "$package" &> /dev/null; then
        print_info "Installing $name..."
        case $PKG_MANAGER in
            apt)
                sudo apt-get install -y "$package"
                ;;
            yum)
                sudo yum install -y "$package"
                ;;
            pacman)
                sudo pacman -S --noconfirm "$package"
                ;;
            brew)
                brew install "$package"
                ;;
        esac
        print_status "$name installed"
    else
        print_status "$name already installed"
    fi
}

# Install essential tools
install_package "git" "Git"
install_package "curl" "cURL"
install_package "wget" "Wget"

# Install modern replacements
print_info "Installing modern CLI replacements..."

# exa (better ls)
if ! command -v exa &> /dev/null; then
    case $PKG_MANAGER in
        apt)
            sudo apt-get install -y exa 2>/dev/null || {
                print_info "Installing exa from cargo..."
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                source $HOME/.cargo/env
                cargo install exa
            }
            ;;
        brew)
            brew install exa
            ;;
        pacman)
            sudo pacman -S --noconfirm exa
            ;;
    esac
    print_status "exa installed"
else
    print_status "exa already installed"
fi

# bat (better cat)
if ! command -v bat &> /dev/null; then
    case $PKG_MANAGER in
        apt)
            sudo apt-get install -y bat 2>/dev/null || {
                wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb
                sudo dpkg -i bat_0.24.0_amd64.deb
                rm bat_0.24.0_amd64.deb
            }
            # On Ubuntu/Debian, bat is installed as batcat
            if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
                mkdir -p ~/.local/bin
                ln -s /usr/bin/batcat ~/.local/bin/bat
            fi
            ;;
        brew)
            brew install bat
            ;;
        pacman)
            sudo pacman -S --noconfirm bat
            ;;
    esac
    print_status "bat installed"
else
    print_status "bat already installed"
fi

# fd (better find)
if ! command -v fd &> /dev/null; then
    case $PKG_MANAGER in
        apt)
            sudo apt-get install -y fd-find 2>/dev/null || {
                wget https://github.com/sharkdp/fd/releases/download/v9.0.0/fd_9.0.0_amd64.deb
                sudo dpkg -i fd_9.0.0_amd64.deb
                rm fd_9.0.0_amd64.deb
            }
            # On Ubuntu/Debian, fd is installed as fdfind
            if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
                mkdir -p ~/.local/bin
                ln -s $(which fdfind) ~/.local/bin/fd
            fi
            ;;
        brew)
            brew install fd
            ;;
        pacman)
            sudo pacman -S --noconfirm fd
            ;;
    esac
    print_status "fd installed"
else
    print_status "fd already installed"
fi

# ripgrep (better grep)
if ! command -v rg &> /dev/null; then
    case $PKG_MANAGER in
        apt)
            sudo apt-get install -y ripgrep
            ;;
        brew)
            brew install ripgrep
            ;;
        pacman)
            sudo pacman -S --noconfirm ripgrep
            ;;
    esac
    print_status "ripgrep installed"
else
    print_status "ripgrep already installed"
fi

# tree
install_package "tree" "tree"

# ============================================================================
# 3. Install FZF
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 4: Installing FZF (Fuzzy Finder)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ ! -d ~/.fzf ]; then
    print_info "Cloning FZF repository..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    print_info "Installing FZF..."
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    print_status "FZF installed"
else
    print_status "FZF already installed"
fi

# ============================================================================
# 4. Install Zinit (Plugin Manager)
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 5: Installing Zinit (ZSH Plugin Manager)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    print_info "Installing Zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    print_status "Zinit installed"
else
    print_status "Zinit already installed"
fi

# ============================================================================
# 6. Backup and Install Config Files
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 6: Installing Configuration Files${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Backup existing configs
if [ -f ~/.zshrc ]; then
    print_info "Backing up existing .zshrc to ~/.zshrc.backup"
    cp ~/.zshrc ~/.zshrc.backup
fi

if [ -f ~/.p10k.zsh ]; then
    print_info "Backing up existing .p10k.zsh to ~/.p10k.zsh.backup"
    cp ~/.p10k.zsh ~/.p10k.zsh.backup
fi

# Copy new configs (assuming they're in the current directory)
if [ -f .zshrc ]; then
    cp .zshrc ~/.zshrc
    print_status "Installed .zshrc"
fi

if [ -f .p10k.zsh ]; then
    cp .p10k.zsh ~/.p10k.zsh
    print_status "Installed .p10k.zsh"
fi

# ============================================================================
# 5. Set ZSH as Default Shell
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 7: Setting ZSH as Default Shell${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Changing default shell to ZSH..."
    chsh -s $(which zsh)
    print_status "Default shell set to ZSH"
    print_info "You may need to log out and log back in for the change to take effect"
else
    print_status "ZSH is already the default shell"
fi

# ============================================================================
# Final Steps
# ============================================================================
echo -e "\n${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  Installation Complete! 🎉                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. Set your terminal font to ${GREEN}MesloLGS NF${NC}"
echo -e "  2. Restart your terminal or run: ${GREEN}exec zsh${NC}"
echo -e "  3. The first time you start ZSH, plugins will be installed automatically"
echo -e "  4. Enjoy your beautiful new ZSH setup!"
echo ""
echo -e "${YELLOW}Useful Commands:${NC}"
echo -e "  • ${GREEN}fcd${NC} - Fuzzy find and cd into directory"
echo -e "  • ${GREEN}fh${NC} - Fuzzy search command history"
echo -e "  • ${GREEN}fkill${NC} - Fuzzy find and kill process"
echo -e "  • ${GREEN}CTRL+R${NC} - Search history with FZF"
echo -e "  • ${GREEN}CTRL+T${NC} - Search files with FZF"
echo -e "  • ${GREEN}ALT+C${NC} - Search directories with FZF"
echo -e "  • ${GREEN}Arrow Keys${NC} - Navigate through command history"
echo ""
echo -e "${YELLOW}Customization:${NC}"
echo -e "  • Run ${GREEN}p10k configure${NC} to customize Powerlevel10k theme"
echo -e "  • Edit ${GREEN}~/.zshrc${NC} to add your own aliases and functions"
echo ""

# Offer to start ZSH now
echo -e "${YELLOW}Would you like to start ZSH now? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    exec zsh
fi
