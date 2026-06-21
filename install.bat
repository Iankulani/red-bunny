@echo off
:: ============================================
:: 🐇 RED_BUNNY v2.0.0 - Windows Installer
:: Author: Ian Carter Kulani, MSc
:: ============================================

setlocal enabledelayedexpansion

color 0C
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║        🐇 RED_BUNNY v2.0.0    ^|    Windows Installation              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Check Python
echo [*] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo [!] Python not found!
    echo [*] Please install Python 3.8+ from https://www.python.org/downloads/
    echo [*] Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

python -c "import sys; exit(0 if sys.version_info >= (3,8) else 1)"
if errorlevel 1 (
    echo [!] Python 3.8+ required!
    pause
    exit /b 1
)

echo [*] Python found!

:: Check pip
echo [*] Checking pip...
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo [!] pip not found, installing...
    python -m ensurepip
)

:: Create virtual environment
echo [*] Creating virtual environment...
if exist venv (
    echo [!] Removing existing venv...
    rmdir /s /q venv
)
python -m venv venv

:: Activate and install
echo [*] Installing Python packages...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

:: Create configuration
echo [*] Creating configuration...
if not exist ".red_bunny" mkdir ".red_bunny"
if not exist ".red_bunny\config.json" (
    type nul > ".red_bunny\config.json"
    echo {>> ".red_bunny\config.json"
    echo     "monitoring": {"enabled": true, "port_scan_threshold": 10},>> ".red_bunny\config.json"
    echo     "scanning": {"default_ports": "1-1000", "timeout": 30},>> ".red_bunny\config.json"
    echo     "security": {"auto_block": false, "log_level": "INFO"},>> ".red_bunny\config.json"
    echo     "nikto": {"enabled": true, "timeout": 300},>> ".red_bunny\config.json"
    echo     "traffic_generation": {"enabled": true, "max_duration": 300, "allow_floods": false},>> ".red_bunny\config.json"
    echo     "social_engineering": {"enabled": true, "default_port": 8080, "capture_credentials": true},>> ".red_bunny\config.json"
    echo     "ssh": {"enabled": true, "default_timeout": 30, "max_connections": 5},>> ".red_bunny\config.json"
    echo     "discord": {"enabled": false, "token": "", "prefix": "!"},>> ".red_bunny\config.json"
    echo     "telegram": {"enabled": false, "api_id": "", "api_hash": "", "bot_token": ""},>> ".red_bunny\config.json"
    echo     "slack": {"enabled": false, "bot_token": "", "channel_id": "", "prefix": "!"},>> ".red_bunny\config.json"
    echo     "whatsapp": {"enabled": false, "phone_number": "", "prefix": "/"},>> ".red_bunny\config.json"
    echo     "imessage": {"enabled": false, "phone_numbers": [], "prefix": "!"},>> ".red_bunny\config.json"
    echo     "signal": {"enabled": false, "webhook_url": "", "prefix": "!"},>> ".red_bunny\config.json"
    echo     "web": {"enabled": true, "port": 8080},>> ".red_bunny\config.json"
    echo     "phishing": {"default_port": 8080, "capture_credentials": true},>> ".red_bunny\config.json"
    echo     "red_bunny": {"theme": "red", "version": "2.0.0"}>> ".red_bunny\config.json"
    echo }>> ".red_bunny\config.json"
)

:: Create launcher
echo [*] Creating launcher...
type nul > redbunny.bat
echo @echo off >> redbunny.bat
echo call venv\Scripts\activate.bat >> redbunny.bat
echo python red_bunny.py %%* >> redbunny.bat

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║        🐇 RED_BUNNY v2.0.0    ^|    Installation Complete!              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo [*] To run RedBunny:
echo     redbunny.bat
echo.
echo [*] Configuration: .red_bunny\config.json
echo [*] Logs: .red_bunny\red_bunny.log
echo [*] Database: .red_bunny\red_bunny.db
echo.
pause