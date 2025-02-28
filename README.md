# 🛡️ MullvScript

MullvScript is an interactive Bash script designed to simplify managing your Mullvad VPN account via the command line. With a user-friendly, colorful interface, the script enables you to authenticate, connect, disconnect, and configure various aspects of your Mullvad account quickly and efficiently.

---

## 📌 Requirements and Dependencies

To run MullvScript, the following binaries must be installed:

- **🔗 mullvad** – Mullvad VPN client.
- **📝 sed**
- **🔍 grep**
- **📊 awk**
- **🌐 curl**
- **🧮 bc**

If any are missing, the script will automatically update the repositories and install the missing binaries using `apt` (on compatible systems).

---

## 🛠️ Installation

### 📋 Prerequisites
Ensure you are using a Linux system with the `apt` package manager (for Debian/Ubuntu-based distributions) and that the Mullvad VPN client is installed.

### 📥 Download
Clone or download the script from the repository:

```bash
 git clone https://github.com/EndlssNightmare/MullvScript.git
```

### 📝 Permissions
Make the script executable:

```bash
chmod +x mullvscript.sh
```

### 🚀 Execution
Start the script:

```bash
./mullvscript.sh
```

---

## ⚙️ Configuration

### 🔐 MULLV_AUTH Environment Variable

The script uses the `MULLV_AUTH` environment variable to store your Mullvad account ID (a 16-digit number).

- If the variable is not set, the script will prompt you to enter the account ID.
- The value is then added to your shell’s configuration file (e.g., `~/.bashrc` or `~/.zshrc`) for persistence across sessions.

### 🖥️ Shell Configuration

The script detects your current shell (bash, zsh, etc.) and sets the appropriate configuration file. If necessary, it reloads the configuration to apply the changes.

---

## 🎮 Usage

When you start the script, it displays an animated banner followed by an interactive menu. Simply type the number corresponding to your desired action and press **Enter**.

### 📜 Menu Options

- **🔓 Login:**  
  Authenticates using the account ID stored in `MULLV_AUTH` and connects to the VPN. If an error occurs (e.g., account non-existent or revoked), the script will prompt for a new ID.

- **🚪 Logout:**  
  Disconnects the current VPN session.

- **🌎 Change Region:**  
  Lists available regions and lets you set a new connection region (e.g., `se/br`).

- **📵 Revoke Account:**  
  Displays devices associated with your account and allows you to revoke access for a specific device.

- **📄 My Account:**  
  Displays detailed account information and the current VPN status.

- **🔄 Switch Account:**  
  Prompts you to enter a new 16-digit account ID, allowing you to switch to another Mullvad account.

- **🔒 Lock Mode:**  
  Activates or deactivates Lockdown Mode, which blocks network traffic if the VPN connection drops.

- **🕶️ Stealth Mode:**  
  Enables or disables Stealth Mode (Bridge) to help mask VPN traffic for enhanced privacy.

- **🔀 Change Protocol:**  
  Allows you to switch between OpenVPN and WireGuard protocols.

- **🔄 Reload Banner:**  
  Clears the screen and reloads the banner and main menu.

- **❌ Exit:**  
  Exits the script, removes temporary files, and ends the interactive session.

- **🆘 Help Menu:**  
  Displays a detailed help message explaining all available commands and functionalities.

---

## 🔄 Execution Flow

1. **🚀 Initialization:**  
   - The script sets up color variables, detects the current shell, and configures the appropriate configuration file.  
   - It loads environment variables from `~/.bashrc` and `~/.zshrc` (if they exist).  
   - An animated banner is displayed.

2. **📦 Dependency Check:**  
   - Verifies if all necessary binaries are installed. Missing binaries are installed automatically if required.

3. **🔑 Account Setup:**  
   - If the `MULLV_AUTH` variable is not set, the script prompts for the account ID and stores it.

4. **📜 Interactive Menu:**  
   - A loop displays the menu and waits for user input, executing the corresponding action based on the selected option.

5. **🎭 User Feedback:**  
   - Each action provides visual feedback (spinner animations and colored messages) to indicate progress and status.

---

## ⚠️ Troubleshooting

- **❌ Invalid Account ID:**  
  If the entered ID is not exactly 16 digits, the script will display an error and prompt for a new value.

- **⚙️ Missing Dependencies:**  
  If a required binary is not installed, the script will attempt to install it automatically using `apt`.  
  Ensure you have superuser permissions to install packages.

- **🔑 Connection/Authentication Errors:**  
  If an error occurs during authentication (e.g., non-existent or revoked account), follow the on-screen instructions to resolve the issue.

- **🖥️ Shell Issues:**  
  The script attempts to identify and use the correct shell configuration file. If problems arise, manually check the appropriate file (`~/.bashrc` or `~/.zshrc`) and adjust as needed.

---

## 🎖️ Credits

- [EndlssNightmare](https://github.com/EndlssNightmare)
- [SmartFox](https://github.com/Smarttfoxx)

## 📜 License

This script is distributed under the same license as the original repository. Please refer to the LICENSE file in the repository for more details.

---

## 🎯 Final Considerations

MullvScript is designed to simplify the management of your Mullvad VPN account with an interactive and visually appealing interface. Enjoy the features and feel free to contribute or suggest improvements on the official GitHub repositories.


