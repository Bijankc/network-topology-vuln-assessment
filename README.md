# Automated Network Topology Mapping and Vulnerability Assessment System

A capstone project that automatically discovers and maps the topology of a network and assesses the hosts it finds for known vulnerabilities. Development and testing run against a self-contained Containerlab lab of FRR routers and intentionally vulnerable containers (Metasploitable2, DVWA, Apache httpd 2.4.49), so every scan targets infrastructure that exists only on the lab host.

> **Authorized use only.** This tool performs active network discovery and vulnerability scanning. Use it only on isolated lab networks or systems you own or have explicit written permission to test. Never point it at production, public, or third-party networks.

## Layout

| Path | Purpose |
|---|---|
| `lab/` | Containerlab topology, router configs, lab host scripts |
| `backend/` | Discovery, scanning, and API service |
| `frontend/` | Web UI |
| `data/` | Sample and generated data |
| `docs/` | Documentation; see [`docs/SETUP.md`](docs/SETUP.md) for host setup |
