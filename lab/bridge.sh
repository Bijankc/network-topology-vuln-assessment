#!/usr/bin/env bash
# Create the br-servers Linux bridge on the host. Needs root; safe to re-run.
# Run before deploying the lab: sudo lab/bridge.sh
set -euo pipefail

BR=br-servers

ip link show "$BR" >/dev/null 2>&1 || ip link add "$BR" type bridge
ip link set "$BR" up

# With br_netfilter loaded, frames crossing a bridge pass the host's iptables
# FORWARD chain, where Docker's policy is DROP. Allow traffic within br-servers.
iptables -C FORWARD -i "$BR" -o "$BR" -j ACCEPT 2>/dev/null ||
  iptables -I FORWARD -i "$BR" -o "$BR" -j ACCEPT

echo "$BR is up"
