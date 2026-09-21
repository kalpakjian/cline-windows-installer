# Cline CLI Windows Installer

PowerShell installer script for Cline CLI on Windows. This script works around the npm/Node.js prerequisites by automatically installing Node.js 20+ if needed.

> **Note**: Cline CLI Windows support is currently in preview. Some features may not work as expected.

## Quick Start

### Option 1: One-line install (recommended)

```powershell
irm https://raw.githubusercontent.com/kalpakjian/cline-windows-installer/main/install-cline.ps1 | iex
```

### Option 2: Download and run

```powershell
# Download
irm https://raw.githubusercontent.com/kalpakjian/cline-windows-installer/main/install-cline.ps1 -OutFile install-cline.ps1

# Review (optional but recommended)
notepad install-cline.ps1

# Run
.\install-cline.ps1
```

## What it does

1. Checks if Node.js 20.0.0+ and npm are installed
2. If not, downloads and installs portable Node.js 20.x (no admin required)
3. Adds Node.js to your PATH
4. Runs `npm install -g cline`
5. You can then use `cline` from any terminal

## Requirements

- Windows 10/11
- PowerShell 5.1+ or PowerShell 7+
- Internet connection

## Alternative approach

If you already have PI agent installed, Node.js is already available:

```powershell
# Install PI first (includes Node.js)
powershell -c "irm https://pi.dev/install.ps1 | iex"

# Then install Cline CLI
npm install -g cline
```

## Troubleshooting

### "npm is not recognized"

Make sure Node.js is installed and in your PATH. Run `node --version` and `npm --version` to verify.

### Permission denied errors

This script installs Node.js to `%LOCALAPPDATA%\cline-node` (no admin required). If you still get permission errors, try running PowerShell as Administrator.

### Cline CLI doesn't work on Windows

Cline CLI Windows support is still in preview. If you encounter issues, consider using the VS Code extension instead: [https://marketplace.visualstudio.com/items?itemName=clinelabs.cline-ai](https://marketplace.visualstudio.com/items?itemName=clinelabs.cline-ai)

## Credits

- Original installer: [https://pi.dev/install.ps1](https://pi.dev/install.ps1)
- Cline CLI: [https://cline.bot](https://cline.bot)

## License

MIT
