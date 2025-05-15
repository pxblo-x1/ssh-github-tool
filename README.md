# 🚀 GitHub SSH Key Setup Script

Welcome! This project provides an interactive Bash script to help you generate and configure SSH keys for use with GitHub. It guides you step-by-step to create a secure SSH key, add it to your GitHub account, and configure your SSH client for seamless authentication.

---

## ✨ Features

- 🎨 **Interactive prompts** with color and emoji for a friendly user experience
- 📧 **Email validation** to ensure correct input
- 🔑 **Choice of key type:** modern (ed25519) or legacy (RSA)
- 📝 **Customizable key file name and location**
- ⚡ **Automatic SSH key generation** and addition to the ssh-agent
- 👀 **Displays your public key** and provides clear instructions for adding it to GitHub
- 🤖 **Optional automatic upload** of your public key to GitHub using a personal access token
- 🛠️ **Updates your `~/.ssh/config`** for GitHub usage
- 🔗 **Tests your SSH connection** to GitHub


## 🛠️ Requirements

- 🐧 Bash shell (tested on macOS and Linux)
- 🔐 `ssh-keygen` and `ssh-agent` utilities
- 🌐 `curl` (for optional automatic upload)


## 🚦 Usage

1. **Clone or download this repository.**
2. **Run the script:**
   ```sh
   bash setup-ssh-keys.sh
   ```
3. **Follow the interactive prompts:**
   - 📧 Enter your GitHub email address (validated for correct format)
   - 🔑 Choose the SSH key type (ed25519 recommended)
   - 📝 Optionally specify a custom file name for your key
   - ⚡ The script will generate your SSH key and add it to the ssh-agent
   - 👀 Your public key will be displayed for you to copy
   - 🤖 Optionally, you can upload the key automatically to GitHub by providing your username and a personal access token with `admin:public_key` scope
   - 🛠️ The script will update your SSH config and test the connection to GitHub


## 🔒 Security Notice

- 🚫 **Never share your private key.** Only the public key (`.pub` file) should be uploaded or shared.
- 🛡️ If you use the automatic upload feature, your GitHub personal access token is only used locally and not stored.


## Authors and acknowledgment 🛡

Pablo Pin - devidence.dev ©

## License 🔒

Pablo Pin - devidence.dev ©


