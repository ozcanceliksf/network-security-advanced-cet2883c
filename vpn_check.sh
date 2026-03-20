#!/bin/bash
# ============================================================
# vpn_check.sh — VPN & Tunnel Status Checker
# Author: Ozcan Celik | Network Security Advanced CET2883C
# ============================================================

echo "============================================"
echo " VPN & TUNNEL STATUS CHECK"
echo " $(date)"
echo "============================================"

# Check active VPN interfaces
echo ""
echo "[*] Active Network Interfaces:"
ip link show | grep -E "^[0-9]+:" | awk '{print "    "$2}' | sed 's/://'

# Check for VPN-related interfaces (tun/tap)
echo ""
echo "[*] VPN Tunnels (tun/tap):"
VPN_FOUND=0
ip link show | grep -E "tun|tap|vpn|wg" && VPN_FOUND=1
if [ $VPN_FOUND -eq 0 ]; then
  echo "    No active VPN tunnels detected"
fi

# Check routing table
echo ""
echo "[*] Routing Table:"
ip route show | head -10

# Check open ports
echo ""
echo "[*] Listening Ports:"
ss -tlnp 2>/dev/null | grep LISTEN | awk '{print "    "$4}' | head -15

# Check firewall status
echo ""
echo "[*] Firewall Status (iptables):"
if command -v iptables &>/dev/null; then
  iptables -L INPUT --line-numbers 2>/dev/null | head -10
else
  echo "    iptables not available"
fi

# Check IDS/IPS (Snort/Suricata)
echo ""
echo "[*] IDS/IPS Services:"
for svc in snort suricata fail2ban; do
  if systemctl is-active --quiet "$svc" 2>/dev/null; then
    echo "    [RUNNING] $svc"
  else
    echo "    [STOPPED] $svc"
  fi
done

echo ""
echo "[+] Check complete."
echo "============================================"
