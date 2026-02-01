# Dotfiles

My Personal dotfiles managed using **GNU Stow**. This repo keeps shell, prompt, and terminal configuration clean, reproducible, and symlink-based.

---

## 📁 Repository Structure

```bash
dotfiles/
├── zsh/
│   ├── .zshrc
│   └── .p10k.zsh
├── iterm2/
│   └── Default.json
├── scripts/
│   └── install.sh
└── README.md
```

Each folder represents a **stow package**. Files inside a package mirror their final location in `$HOME`.

---
## Setting Gitthub
- Follow steps to setup ssh https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- Add ssh key in your github account
- Happy Comitting!!


## 🧩 Prerequisites

- macOS or Linux
- `zsh`
- `git`
- **GNU Stow**

Install stow:

```bash
# macOS
brew install stow

# Ubuntu / Debian
sudo apt install stow
```

---

## 🔗 Installing Dotfiles (Using Stow)

Clone the repository:

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Zsh + Powerlevel10k

```bash
stow zsh
```

This creates:

```bash
~/.zshrc    -> ~/dotfiles/zsh/.zshrc
~/.p10k.zsh -> ~/dotfiles/zsh/.p10k.zsh
```

Make sure `.zshrc` contains:

```zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
```

---

### Scripts

```bash
chmod +x scripts/install.sh
stow scripts
```

---

## 🖥 iTerm2 Configuration

macOS does not auto-load iTerm2 profiles from dotfiles.

To import:
1. Open **iTerm2 → Settings → Profiles**
2. Click **Import**
3. Select:

```bash
~/dotfiles/iterm2/Default.json
```

The file is version-controlled here for portability and backup.

---

## 🧪 Dry Run (Recommended)

Before stowing any package:

```bash
stow -nv zsh
```

---

## 🛠 Troubleshooting

**File already exists error**

```bash
rm ~/.zshrc ~/.p10k.zsh
stow zsh
```

**Verify symlink**

```bash
ls -l ~/.zshrc
```

Expected output:

```bash
.zshrc -> dotfiles/zsh/.zshrc
```

---

## 🚀 One-Command Setup (Optional)

```bash
cd ~/dotfiles
stow zsh scripts
```

---

### Custom Commands

| Command | Description |
|---------|-------------|
| `fcd` | Fuzzy find and cd into directory |
| `fh` | Fuzzy search command history |
| `fkill` | Fuzzy find and kill process |
| `mkcd <dir>` | Create directory and cd into it |
| `extract <file>` | Extract any archive format |
| `gcl <repo>` | Git clone and cd into directory |
| `z <keyword>` | Jump to frequently used directories |


## 📌 Notes

- Add new tools by creating a new folder and stowing it
- Never edit symlinked files directly in `$HOME`
- Always edit files inside `~/dotfiles`

---



