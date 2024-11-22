from setuptools import setup, find_packages

setup(
    name='RAGscriptingCrawler',
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
