cd C:\Users\princ\cline-windows-installer
git init
git add .
git commit -m "Initial commit: Cline CLI Windows installer

- install-cline.ps1: PowerShell installer based on pi.dev/install.ps1
- README.md: Usage instructions and troubleshooting

Note: Cline CLI Windows support is in preview."
git branch -M main
gh repo create cline-windows-installer --public --description "PowerShell installer script for Cline CLI on Windows (works around npm/Node.js prerequisites)" --source=. --remote=origin --push

# Remove temporary script and push
git rm git-push.ps1
git commit -m "Remove temporary git push script"
git push
