#!/usr/bin/env bash
# Configure nodes whose image has no `ip` command. Needs root; safe to re-run.
# Runs the host's `ip` inside the container's network namespace (nsenter -n).
# Run after deploying the lab: sudo lab/post-deploy.sh
set -euo pipefail

in_netns() {
  local pid
  pid=$(docker inspect -f '{{.State.Pid}}' "clab-capstone-$1")
  shift
  nsenter -t "$pid" -n "$@"
}

# httpd: server network, plus a route to the rest of the lab via r2
in_netns httpd ip addr replace 10.10.20.20/24 dev eth1
in_netns httpd ip route replace 10.10.0.0/16 via 10.10.20.1

echo "post-deploy done"
