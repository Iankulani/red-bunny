#!/usr/bin/env python3
"""
🐇 RED_BUNNY v2.0.0 - Setup
Author: Ian Carter Kulani, MSc
"""

from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="red-bunny",
    version="2.0.0",
    author="Ian Carter Kulani, MSc",
    author_email="iancarterkulani@protonmail.com",
    description="🐇 Ultimate Multi-Platform Phishing & Command Center",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/IanCarterKulani/red-bunny",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "License :: Other/Proprietary License",
        "Operating System :: OS Independent",
        "Development Status :: 4 - Beta",
        "Intended Audience :: Information Technology",
        "Topic :: Security",
        "Topic :: System :: Networking",
        "Environment :: Console",
    ],
    python_requires=">=3.8",
    install_requires=[
        "requests>=2.31.0",
        "colorama>=0.4.6",
        "psutil>=5.9.5",
        "cryptography>=41.0.0",
        "Flask>=2.3.0",
        "flask-socketio>=5.3.0",
        "python-socketio>=5.9.0",
        "paramiko>=3.3.1",
        "python-whois>=0.7.3",
        "scapy>=2.5.0",
        "pyshorteners>=1.0.1",
        "qrcode>=7.4.2",
        "Pillow>=10.0.0",
        "discord.py>=2.3.0",
        "telethon>=1.35.0",
        "slack-sdk>=3.23.0",
        "selenium>=4.15.0",
        "webdriver-manager>=4.0.1",
        "pyyaml>=6.0",
        "tqdm>=4.66.0",
        "prettytable>=3.9.0",
        "dnspython>=2.4.0",
    ],
    entry_points={
        "console_scripts": [
            "redbunny=red_bunny:main",
        ],
    },
)