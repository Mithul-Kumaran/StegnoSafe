#!/bin/bash

# ====================================
# MK Steganography Script using Outgess
# Author: MK
# Compatible: Ubuntu/Debian
# Usage:
#   chmod +x mk_steg.sh && ./mk_steg.sh
# ====================================

# Auto-install outguess if not present
install_outguess() {
    if ! command -v outguess &> /dev/null; then
        echo "[*] Installing required tool..."
        sudo apt update && sudo apt install outguess -y
        if [ $? -ne 0 ]; then
            echo "[-] Failed to install required tool. Exiting."
            exit 1
        fi
    fi
}

# Encode secret into image
encode_message() {
    echo
    echo "[Encode Mode]"

    read -p "Enter path to cover image (e.g., image.jpg): " cover_image
    [[ ! -f "$cover_image" ]] && echo "[-] File not found: $cover_image" && exit 1

    read -p "Enter path to secret message file (e.g., secret.txt): " secret_file
    [[ ! -f "$secret_file" ]] && echo "[-] File not found: $secret_file" && exit 1

    read -p "Enter output image filename (e.g., output.jpg): " output_image

    echo "[*] Embedding message..."
    outguess -k "" -d "$secret_file" "$cover_image" "$output_image"

    if [ $? -eq 0 ]; then
        echo "[+] Secret embedded successfully into '$output_image'"
    else
        echo "[-] Failed to embed message."
    fi
}

# Decode message from image
decode_message() {
    echo
    echo "[Decode Mode]"

    read -p "Enter path to stego image (e.g., output.jpg): " stego_image
    [[ ! -f "$stego_image" ]] && echo "[-] File not found: $stego_image" && exit 1

    read -p "Enter output filename to save extracted message (e.g., extracted.txt): " extracted_file

    echo "[*] Extracting message..."
    outguess -k "" -r "$stego_image" "$extracted_file"

    if [ $? -eq 0 ]; then
        echo "[+] Extraction successful. Contents of '$extracted_file':"
        echo "----------------------------------------"
        cat "$extracted_file"
        echo "----------------------------------------"
        rm -f "$extracted_file"
    else
        echo "[-] Failed to extract message."
    fi
}

# === Main ===

clear
echo "==================================="
echo "         MK's Steganography Tool"
echo "==================================="

install_outguess

echo
echo "Select an option:"
echo "1) Encode (hide secret in image)"
echo "2) Decode (extract secret from image)"
read -p "Enter your choice [1/2]: " choice

case "$choice" in
    1) encode_message ;;
    2) decode_message ;;
    *) echo "[-] Invalid option. Please enter 1 or 2." && exit 1 ;;
esac
