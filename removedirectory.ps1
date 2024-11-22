# Define the project structure
$folders = @(
    "src",
    "src\utils",
    "tests",
    "docs",
    "infra"
)

$files = @(
    "README.md",
    "requirements.txt",
    "setup.py",
    "main.py",
    ".gitignore",
    "src\__init__.py",
    "src\database.py",
    "src\crawler.py",
    "src\openai_helper.py",
    "src\utils\__init__.py",
    "src\utils\helper.py",
    "tests\__init__.py",
    "tests\test_module1.py",
    "tests\test_module2.py",
    "tests\test_helper.py",
    "docs\index.md"
)

# Delete the files
foreach ($file in $files) {
    if (Test-Path -Path $file) {
        Remove-Item -Path $file -Force
    }
}

# Delete the folders
foreach ($folder in $folders) {
    if (Test-Path -Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
    }
}

Write-Host "Project structure deleted successfully."