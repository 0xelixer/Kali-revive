#!/bin/bash

set -e

source "conf.sh"

PROGRAM_PREFIX=""

# Warn if install directory is not in PATH
if ! echo "$PATH" | grep -q "$DIR"; then
    echo "Warning: '$DIR' is not in your PATH."
    echo "         To use this program add '$DIR'"
    echo "         to your PATH or manually copy"
    echo "         katoolin3.py somewhere."
    echo
    PROGRAM_PREFIX="$DIR/"
fi

# Check python3 exists
if ! command -v python3 >/dev/null 2>&1; then
    echo "Please install 'python3'"
    exit 1
fi

# Update package lists
sudo apt update -qq

# Install required dependencies safely
sudo apt install -y python3-apt gnupg curl || {
    echo "Dependency installation failed"
    exit 1
}

# Add Kali archive key (modern method — no apt-key)
KEYRING="/usr/share/keyrings/kali-archive-keyring.gpg"

if [ ! -f "$KEYRING" ]; then
    curl -fsSL https://archive.kali.org/archive-key.asc | \
        sudo gpg --dearmor -o "$KEYRING" || {
        echo "Failed to import Kali GPG key"
        exit 1
    }
fi

# Install program
sudo install -T -g root -o root -m 555 ./katoolin3.py "$DIR/$PROGRAM" || {
    echo "Installation failed"
    exit 1
}

echo
echo "Successfully installed."
echo "Run it with: sudo $PROGRAM_PREFIX$PROGRAM"
exit 0
