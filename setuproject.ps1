
# Define the project name
$projectName = "RAGscriptingCrawler"

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
    ".env", # Add .env file
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

# Create the folders
foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force
}

# Create the files
foreach ($file in $files) {
    New-Item -ItemType File -Path $file -Force
}

# Add basic content to setup.py
$setupPyContent = @"
from setuptools import setup, find_packages

setup(
    name='$projectName',
    version='0.1.0',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    install_requires=[
        # List your project's dependencies here.
        # Example: 'requests>=2.20.0',
        'requests',
        'beautifulsoup4',
        'python-dotenv',
        'openai',
        'psycopg2',
        'langchain_community'
    ],
    entry_points={
        'console_scripts': [
            # Define command-line scripts here.
            # Example: 'your_command=your_module:main_function',
        ],
    },
    author='Your Name',
    author_email='your.email@example.com',
    description='A short description of your project',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url='https://github.com/yourusername/yourproject',
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)
"@

Set-Content -Path "setup.py" -Value $setupPyContent

Write-Host "Project structure created successfully."