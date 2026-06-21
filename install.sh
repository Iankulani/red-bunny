#!/bin/bash
# ============================================
# 🐇 RED_BUNNY v2.0.0 - Bash Installer
# Author: Ian Carter Kulani, MSc
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
NC='\033[0m'

BANNER="
${RED}╔══════════════════════════════════════════════════════════════════════════════╗
║${WHITE}        🐇 RED_BUNNY v2.0.0    |    Installation Script              ${RED}║
╚══════════════════════════════════════════════════════════════════════════════╝${NC}
"

echo -e "$BANNER"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            echo "$ID"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
echo -e "${BLUE}🔍 Detected OS: ${OS}${NC}"

# Check Python
check_python() {
    if command -v python3 &>/dev/null; then
        PYTHON_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        echo -e "${GREEN}✅ Python $PYTHON_VER found${NC}"
        return 0
    else
        echo -e "${RED}❌ Python3 not found${NC}"
        return 1
    fi
}

# Install system dependencies
install_system_deps() {
    echo -e "${BLUE}📦 Installing system dependencies...${NC}"
    
    case $OS in
        ubuntu|debian|linuxmint)
            sudo apt-get update
            sudo apt-get install -y \
                python3 python3-pip python3-dev python3-venv \
                nmap nikto traceroute dnsutils \
                git curl wget build-essential \
                iptables net-tools \
                chromium-browser \
                sshpass \
                libpcap-dev \
                python3-gi \
                libssl-dev
            ;;
        
        fedora|centos|rhel)
            sudo yum install -y \
                python3 python3-pip python3-devel \
                nmap nikto traceroute bind-utils \
                git curl wget gcc \
                iptables net-tools \
                chromium \
                sshpass \
                libpcap-devel \
                openssl-devel
            ;;
        
        macos)
            if ! command -v brew &>/dev/null; then
                echo -e "${YELLOW}⚠️ Homebrew not found. Installing...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install \
                python3 nmap nikto traceroute \
                git curl wget \
                chromium \
                sshpass \
                libpcap \
                openssl
            ;;
        
        windows)
            echo -e "${YELLOW}⚠️ Windows detected. Installing with pip only...${NC}"
            ;;
        
        *)
            echo -e "${YELLOW}⚠️ Unknown OS. Installing with pip only...${NC}"
            ;;
    esac
}

# Create virtual environment
setup_venv() {
    echo -e "${BLUE}🔧 Creating virtual environment...${NC}"
    if [ -d "venv" ]; then
        echo -e "${YELLOW}⚠️ Existing venv found. Removing...${NC}"
        rm -rf venv
    fi
    python3 -m venv venv
    source venv/bin/activate
}

# Install Python packages
install_python_packages() {
    echo -e "${BLUE}📦 Installing Python packages...${NC}"
    pip install --upgrade pip
    pip install -r requirements.txt
    pip install -e .
}

# Install optional tools
install_optional_tools() {
    echo -e "${BLUE}🔧 Installing optional tools...${NC}"
    
    # Signal CLI
    if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
        echo -e "${YELLOW}📱 Signal CLI (optional)...${NC}"
        # Signal-cli installation instructions
        echo -e "${YELLOW}  Visit: https://github.com/AsamK/signal-cli${NC}"
    fi
    
    # WhatsApp Web Driver
    if [[ "$OS" == "linux" ]] || [[ "$OS" == "macos" ]]; then
        echo -e "${GREEN}✅ Chrome driver will be auto-installed${NC}"
    fi
}

# Create configuration
create_config() {
    echo -e "${BLUE}⚙️ Creating configuration...${NC}"
    mkdir -p .red_bunny
    if [ ! -f ".red_bunny/config.json" ]; then
        cat > .red_bunny/config.json << 'EOF'
{
    "monitoring": {"enabled": true, "port_scan_threshold": 10},
    "scanning": {"default_ports": "1-1000", "timeout": 30},
    "security": {"auto_block": false, "log_level": "INFO"},
    "nikto": {"enabled": true, "timeout": 300},
    "traffic_generation": {"enabled": true, "max_duration": 300, "allow_floods": false},
    "social_engineering": {"enabled": true, "default_port": 8080, "capture_credentials": true},
    "ssh": {"enabled": true, "default_timeout": 30, "max_connections": 5},
    "discord": {"enabled": false, "token": "", "prefix": "!"},
    "telegram": {"enabled": false, "api_id": "", "api_hash": "", "bot_token": ""},
    "slack": {"enabled": false, "bot_token": "", "channel_id": "", "prefix": "!"},
    "whatsapp": {"enabled": false, "phone_number": "", "prefix": "/"},
    "imessage": {"enabled": false, "phone_numbers": [], "prefix": "!"},
    "signal": {"enabled": false, "webhook_url": "", "prefix": "!"},
    "web": {"enabled": true, "port": 8080},
    "phishing": {"default_port": 8080, "capture_credentials": true},
    "red_bunny": {"theme": "red", "version": "2.0.0"}
}
EOF
        echo -e "${GREEN}✅ Config created at .red_bunny/config.json${NC}"
    fi
}

# Create launcher script
create_launcher() {
    echo -e "${BLUE}🚀 Creating launcher...${NC}"
    cat > redbunny << 'EOF'
#!/bin/bash
source venv/bin/activate
python3 red_bunny.py "$@"
EOF
    chmod +x redbunny
}

# Main installation
main() {
    echo -e "${BLUE}🚀 Starting RedBunny installation...${NC}"
    
    # Check Python
    if ! check_python; then
        echo -e "${RED}❌ Python3 is required. Please install Python 3.8+${NC}"
        exit 1
    fi
    
    # Install system dependencies
    install_system_deps
    
    # Setup virtual environment
    setup_venv
    
    # Install Python packages
    install_python_packages
    
    # Install optional tools
    install_optional_tools
    
    # Create configuration
    create_config
    
    # Create launcher
    create_launcher
    
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║${WHITE}        🐇 RED_BUNNY v2.0.0    |    Installation Complete!              ${GREEN}║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "\n${WHITE}🎯 To run RedBunny:${NC}"
    echo -e "  ${GREEN}./redbunny${NC}"
    echo -e "  or"
    echo -e "  ${GREEN}source venv/bin/activate && python3 red_bunny.py${NC}"
    echo -e "\n${WHITE}📁 Configuration: .red_bunny/config.json${NC}"
    echo -e "${WHITE}📊 Logs: .red_bunny/red_bunny.log${NC}"
    echo -e "${WHITE}💾 Database: .red_bunny/red_bunny.db${NC}"
    echo -e "\n${YELLOW}💡 First run: ./redbunny${NC}"
}

main