# ADR-0013: Boot Environment and Live System Detection

## Status
Accepted

## Context
ghostremaster operates in a hybrid environment:

- A GhostBSD live ISO session (primary use case)
- Potentially an installed GhostBSD system (secondary use case)

We must reliably distinguish:

- The running live environment
- The base ISO filesystem used for comparison
- The active system being modified by the user

Without clear detection rules, the diff engine (ADR-0011) may produce incorrect or unstable results.

## Decision
We will implement a runtime detection system that identifies the execution environment.

### 1. Live system detection

The system is considered "live" if:

- `/etc/rc.conf` indicates a live user session
- Boot media is mounted as read-only (CD9660 or similar)
- `/usr/sbin/bsdinstall` or installer environment is present
- Root filesystem is mounted from a temporary or memory-backed source

### 2. Base ISO detection

The base ISO is identified by:

- Mounted CD9660 filesystem
- Presence of `boot/` and `cdrom/` structure
- Read-only mount flags

### 3. Installed system detection

The system is considered installed if:

- Root filesystem is writable ZFS or UFS dataset
- No live installer environment exists
- Persistent `/etc` and `/var` exist on disk

## Consequences

### Positive
- Enables correct diff baseline selection
- Prevents mixing live system noise with installed system state
- Supports both live and installed workflows

### Negative
- Detection logic may need updates across GhostBSD releases
- Edge cases exist in hybrid boot environments (USB installs, persistence layers)
