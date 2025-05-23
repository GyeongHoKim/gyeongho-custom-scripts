# Gyeongho Custom Scripts

A collection of custom scripts that allow you to use Unix-style commands in Windows PowerShell.

## Installation

### Installation using Scoop

1. First, Scoop must be installed. If it is not installed:

   ```powershell
   irm get.scoop.sh | iex
   ```

2. Add the custom bucket (after uploading to GitHub):

   ```powershell
   scoop bucket add gyeongho-bucket https://github.com/gyeongho/scoop-bucket
   ```

3. Install the scripts:
   ```powershell
   scoop install gyeongho-custom-scripts
   ```

### Manual Installation

1. Clone this repository:

   ```powershell
   git clone https://github.com/gyeongho/gyeongho-custom-scripts.git
   ```

2. Add the script loader to your PowerShell profile:

   ```powershell
   notepad $PROFILE
   ```

3. Add the following content:
   ```powershell
   # Gyeongho Custom Scripts Loader
   $scriptPath = "C:\path\to\gyeongho-custom-scripts\scripts"
   if (Test-Path $scriptPath) {
       Get-ChildItem "$scriptPath\*.ps1" | ForEach-Object {
           . $_.FullName
       }
   }
   ```

## Available Commands

### rm

A file/folder deletion command similar to Unix `rm` command.

**Usage:**

```powershell
# Delete a file
rm file.txt

# Delete a folder and all its contents
rm -r folder

# Force delete
rm -f file.txt

# Recursive force delete
rm -rf folder
```

**Options:**

- `-r`: Delete recursively (folders and all sub-items)
- `-f`: Force delete (without confirmation)
- `-rf` or `-fr`: Recursive force delete

## Adding a New Script

1. Create a new `.ps1` file in the `scripts` folder.
2. Define a function:
   ```powershell
   function command-name {
       param(
           # Define parameters
       )
       # Function logic
   }
   ```
3. Restart PowerShell or run `. $PROFILE`.

## Contributing

1. Fork this repository.
2. Create a new branch: `git checkout -b feature/new-command`
3. Commit your changes: `git commit -am 'Add new command'`
4. Push to your branch: `git push origin feature/new-command`
5. Create a Pull Request.

## License

MIT License

## Author

Gyeongho
