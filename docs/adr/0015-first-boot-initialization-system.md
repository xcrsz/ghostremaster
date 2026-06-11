# ADR-0015: First Boot Initialization System

## Status
Accepted

## Context
A remastered ISO must behave correctly when installed and booted on a new machine.

Challenges include:

- Machine-specific configuration regeneration
- Hostname and network reconfiguration
- SSH key regeneration
- User account initialization
- Hardware adaptation

Without a first-boot system, remastered ISOs may be non-portable or insecure.

## Decision
We will implement a **first-boot initialization system** executed on the first boot of an installed system generated from the ISO.

### 1. Execution model

A first-boot script will run once after installation and then disable itself.

Trigger mechanisms may include:

- Marker file in `/etc/ghostremaster-firstboot.done`
- System service flag
- rc.d initialization hook

### 2. Responsibilities

On first boot, the system will:

- Generate new SSH host keys
- Set hostname based on ISO profile
- Configure network defaults
- Initialize user accounts if required
- Clean temporary installation artifacts

### 3. Idempotency requirement

The initialization system must:

- Run exactly once
- Be safe to re-run without breaking the system
- Leave no persistent installation artifacts

## Consequences

### Positive
- Ensures generated ISOs are portable across machines
- Prevents duplicate identity issues (SSH keys, hostnames)
- Improves security of remastered systems

### Negative
- Requires careful integration with GhostBSD init system
- Must remain compatible with both UFS and ZFS installs
- Adds complexity to installation lifecycle management
