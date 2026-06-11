# ADR-0004: ISO Rebuild Strategy

## Status
Accepted

## Context
We must generate a bootable GhostBSD-compatible ISO from a customized system profile.

GhostBSD already provides ISO structure, boot loader configuration, and installer integration. Rebuilding all of this from scratch would be unnecessarily complex and fragile.

## Decision
We will rebuild the ISO by modifying an extracted official GhostBSD ISO rather than constructing a full operating system build pipeline.

The process will be:

1. Extract official GhostBSD ISO into a working directory
2. Modify the filesystem using captured profile data
3. Apply overlays (configs, packages, user changes)
4. Rebuild filesystem images using FreeBSD tooling
5. Generate a new bootable ISO image

The rebuild process will rely on standard FreeBSD utilities such as:
- makefs
- mkimg
- cd9660 filesystem tools

We explicitly will NOT implement:
- A full OS build system
- A replacement for GhostBSD build infrastructure

## Consequences
- The system depends on the structure of GhostBSD ISO images remaining stable
- Bootloader and installer logic remain intact and unchanged
- The implementation is simpler and more robust than a full OS builder
- Future GhostBSD ISO layout changes may require adjustments in ghostremaster
