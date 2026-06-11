# ADR-0007: Filesystem Diff Engine

## Status
Accepted

## Context
We must compute differences between:

- Base GhostBSD ISO filesystem
- Live customized system

## Decision
We will implement:

- Recursive directory traversal
- SHA256 hashing for file comparison
- Metadata comparison (size, modification time)
- Classification:
  - Added
  - Modified
  - Deleted

## Consequences
- CPU intensive on large systems
- Requires exclusion rules
- Must handle symlinks safely
