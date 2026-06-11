# ADR-0001: Core Goal of ghostremaster

## Status
Accepted

## Context
GhostBSD does not provide a native tool for remastering a customized system into a bootable ISO. Existing tooling (`ghostbsd-build`) is intended for official OS builds, not user-driven system capture.

We want a workflow where:

- A user boots a GhostBSD live ISO
- Installs packages and customizes the system
- Runs a single command
- Produces a bootable ISO identical to that system state

## Decision
We will build a standalone tool (`ghostremaster`) that:

- Does NOT depend on `ghostbsd-build`
- Works on a running GhostBSD system (live or installed)
- Captures system changes (packages, configs, filesystem diffs)
- Rebuilds a bootable ISO using FreeBSD-native tooling (`makefs`, `mkimg`)

## Consequences
- We must implement ISO reconstruction logic ourselves
- We must maintain compatibility with GhostBSD boot structure
- We avoid dependency on GhostBSD internal build pipeline
