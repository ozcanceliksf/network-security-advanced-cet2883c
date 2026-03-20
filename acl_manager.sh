#!/bin/bash
# ============================================================
# acl_manager.sh — Basic ACL & Access Control Management
# Author: Ozcan Celik | Network Security Advanced CET2883C
# ============================================================

ACTION=$1
TARGET=$2

usage() {
  echo "Usage: ./acl_manager.sh [block|allow|status|reset] [ip_address]"
  echo "  block  <ip>  — Block an IP address"
  echo "  allow  <ip>  — Allow a previously blocked IP"
  echo "  status       — Show current block list"
  echo "  reset        — Reset all custom rules"
  exit 1
}

if [ -z "$ACTION" ]; then usage; fi

case $ACTION in
  block)
    if [ -z "$TARGET" ]; then echo "[!] Provide an IP address"; exit 1; fi
    iptables -A INPUT -s "$TARGET" -j DROP
    iptables -A OUTPUT -d "$TARGET" -j DROP
    echo "[+] Blocked: $TARGET"
    ;;
  allow)
    if [ -z "$TARGET" ]; then echo "[!] Provide an IP address"; exit 1; fi
    iptables -D INPUT -s "$TARGET" -j DROP 2>/dev/null
    iptables -D OUTPUT -d "$TARGET" -j DROP 2>/dev/null
    echo "[+] Unblocked: $TARGET"
    ;;
  status)
    echo "============================================"
    echo " CURRENT ACL RULES"
    echo "============================================"
    iptables -L INPUT -v -n --line-numbers | grep DROP
    ;;
  reset)
    echo "[*] Resetting custom DROP rules..."
    iptables -F INPUT
    iptables -F OUTPUT
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    echo "[+] Rules reset."
    ;;
  *)
    usage
    ;;
esac
