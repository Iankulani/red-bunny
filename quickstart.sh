#!/bin/bash
# ============================================
# 🐇 RED_BUNNY v2.0.0 - Quick Start
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}🐇 RED_BUNNY v2.0.0 - Quick Start${NC}"
echo -e "${BLUE}====================================${NC}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}⚠️  Running without root/sudo. Some features may be limited.${NC}"
    echo -e "${YELLOW}   Recommended: sudo ./quickstart.sh${NC}"
    echo ""
fi

# Check Python
if ! command -v python3 &>/dev/null; then
    echo -e "${RED}❌ Python3 not found. Please install Python 3.8+${NC}"
    exit 1
fi

# Make script executable
chmod +x red_bunny.py

# Install if not already installed
if [ ! -d "venv" ]; then
    echo -e "${BLUE}📦 First time setup...${NC}"
    ./install.sh
fi

# Run RedBunny
echo -e "${GREEN}🚀 Starting RedBunny...${NC}"
./redbunny