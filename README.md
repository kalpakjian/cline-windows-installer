# Cline CLI Windows Installer

PowerShell installer script for Cline CLI on Windows. Automatically installs Node.js 20+ if needed.

> **Note**: Cline CLI Windows support is currently in preview. Some features may not work as expected.

## Quick Start

### Minimal Version (Recommended for most users)

```powershell
irm https://tinyurl.com/cline-win | iex
```

Or download and review first:

```powershell
irm https://tinyurl.com/cline-win -OutFile install-cline.ps1
notepad install-cline.ps1
.\install-cline.ps1
```

### Full Version (All features from original pi.dev installer)

```powershell
irm https://raw.githubusercontent.com/kalpakjian/cline-windows-installer/main/install-cline-full.ps1 | iex
```

## Versions Comparison

| Feature | Minimal | Full |
|---------|---------|------|
| Auto-install Node.js | ✅ | ✅ |
| Install Cline CLI | ✅ | ✅ |
| PATH management | Basic | Advanced |
| Progress animations | ❌ | ✅ |
| Color output | ❌ | ✅ |
| Error handling | Basic | Comprehensive |
| Code size | ~150 lines | ~250 lines |
| Best for | Quick install | Debugging/learning |

**Which one should I use?**

- **Minimal version**: If you just want Cline CLI installed quickly
- **Full version**: If you want all features, better error messages, or are learning PowerShell

## What it does

1. ✅ Checks if Node.js 20.0.0+ and npm are installed
2. ✅ Downloads portable Node.js 20.x if missing (no admin required)
3. ✅ Adds Node.js to your PATH
4. ✅ Runs `npm install -g cline`
5. ✅ You can then use `cline` from any terminal

## Requirements

- Windows 10/11
- PowerShell 5.1+ or PowerShell 7+
- Internet connection

## Files in this Repo

- `install-cline.ps1` - Minimal version (recommended)
- `install-cline-full.ps1` - Full version with all features
- `docs/COMPARISON.md` - Detailed comparison

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

Make sure Node.js is installed and in your PATH:

```powershell
node --version
npm --version
```

### Permission denied errors

This script installs Node.js to `%LOCALAPPDATA%\cline-node` (no admin required). If you still get permission errors, try running PowerShell as Administrator.

### Cline CLI doesn't work on Windows

Cline CLI Windows support is still in preview. If you encounter issues:

- Check the [official Cline docs](https://docs.cline.bot)
- Try the [VS Code extension](https://marketplace.visualstudio.com/items?itemName=clinelabs.cline-ai) instead
- Report an issue on this repo

## Security

This script:
- Downloads Node.js from official nodejs.org
- Installs Cline CLI from official npm registry
- Contains no malicious code (review the source!)

**Always review scripts before running them:**

```powershell
irm https://tinyurl.com/cline-win -OutFile install-cline.ps1
notepad install-cline.ps1  # Review first
.\install-cline.ps1        # Then run
```

## Development

### Version History

- **v1.0.0** (2026-09-22) - Initial release with minimal and full versions

### Building

Both versions are hand-crafted PowerShell scripts. The minimal version is optimized for:
- Smaller file size
- Faster execution
- Easier to read and audit

The full version preserves all features from the original pi.dev installer.

## Credits

- Original installer: [pi.dev/install.ps1](https://pi.dev/install.ps1)
- Cline CLI: [cline.bot](https://cline.bot)

## License

MIT License - see [LICENSE](LICENSE) file for details.

