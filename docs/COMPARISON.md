# Version Comparison

This document explains the differences between the minimal and full versions of the Cline CLI installer.

## Minimal Version (`install-cline.ps1`)

### Characteristics

- **~150 lines of code**
- No animations or progress spinners
- Basic error handling
- Simple PATH management
- No color output

### Best For

- Quick installation
- Users who just want Cline CLI working
- Easy auditing and understanding
- Learning PowerShell basics

### Code Changes from Original

Removed:
- Animated logo and title
- Progress spinners and spinners
- Complex PATH management functions
- Color and ANSI escape codes
- Logging and telemetry
- Checksum verification

Kept:
- Node.js version checking
- Automatic Node.js installation
- npm package installation
- Basic error handling

## Full Version (`install-cline-full.ps1`)

### Characteristics

- **~250 lines of code**
- Animated title
- Comprehensive error messages
- Advanced PATH management with HKCU registry
- Color output support
- Preserves all original pi.dev features

### Best For

- Debugging installation issues
- Learning advanced PowerShell
- Users who want all safety checks
- Reference implementation

## Which Should You Use?

| Use Case | Recommended Version |
|----------|---------------------|
| Just install Cline CLI | Minimal |
| Learn PowerShell | Start with Minimal, then Full |
| Debug installation | Full |
| Audit the code | Minimal first, then Full |
| Modify for custom use | Either (Minimal is easier) |

## Security Note

Both versions:
- Download Node.js from official nodejs.org (HTTPS)
- Install Cline CLI from official npm registry
- Can be reviewed before execution

**Recommendation**: Always review the script before running:

```powershell
# Download
irm https://tinyurl.com/cline-win -OutFile install-cline.ps1

# Review
notepad install-cline.ps1

# Then run
.\install-cline.ps1
```
