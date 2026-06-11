# ADR-0012: ISO Assembly Pipeline Design

## Status
Accepted

## Context
ghostremaster must transform a captured system profile into a bootable GhostBSD ISO.

The input to this process is the output of ADR-0011 (filesystem diff engine), including:

- Added files
- Modified files
- Deleted files
- Package list
- Overlay directory

We must define a deterministic pipeline that produces a valid GhostBSD-compatible ISO without relying on ghostbsd-build.

The ISO must remain:
- Bootable on BIOS and UEFI systems
- Compatible with GhostBSD installer expectations
- Structurally consistent with official GhostBSD images

## Decision
We will implement a staged ISO assembly pipeline with the following phases:

---

## Phase 1: Extract base ISO

The official GhostBSD ISO is mounted and extracted into a working directory.

This provides:
- Bootloader configuration
- Kernel and base system layout
- Installer framework
- Live system structure

The extracted ISO acts as the immutable base.

---

## Phase 2: Apply filesystem modifications

The diff output from ADR-0011 is applied:

- Added files are copied into the filesystem
- Modified files overwrite existing base files
- Deleted files are removed from the filesystem tree

This produces a customized root filesystem tree.

---

## Phase 3: Apply overlay layer

The overlay directory from the profile is merged on top of the modified filesystem.

Overlay rules:
- Files in overlay always override base files
- Directory structure is preserved
- Conflicts are resolved by overlay priority (overlay wins)

---

## Phase 4: Rebuild root filesystem image

The modified filesystem tree is converted into a bootable root filesystem image.

This step uses FreeBSD-native tooling such as:

- makefs (for filesystem image creation)
- optional compression tools (e.g., zstd or xz depending on target)

The output is a live-system-compatible root filesystem image.

---

## Phase 5: Integrate boot structure

The original boot components from the extracted ISO are preserved:

- EFI boot files
- BIOS bootloader configuration
- kernel and loader configuration
- installer metadata

Only the root filesystem is replaced or updated.

---

## Phase 6: Rebuild ISO image

A new ISO is generated using a CD9660 filesystem layout.

The ISO includes:
- boot/ directory
- EFI/ directory
- root filesystem image
- installer configuration files

The resulting ISO is made bootable for both BIOS and UEFI systems.

---

## Phase 7: Validation step

The generated ISO is validated for:

- bootability in virtual machines
- presence of kernel and loader files
- correct root filesystem mounting
- installer startup success

Optional automated testing may be added in future ADRs.

---

## Consequences

### Positive
- Fully deterministic ISO generation pipeline
- Independent of ghostbsd-build
- Preserves official GhostBSD boot and installer behavior
- Allows reproducible system remastering from user profiles

### Negative
- Requires detailed knowledge of GhostBSD ISO layout
- Sensitive to changes in GhostBSD release structure
- Risk of breakage if boot or installer internals change
- Complex filesystem handling during rebuild phase

## Notes
This ADR defines the complete transformation pipeline from system diff output to bootable GhostBSD ISO.

All future implementation work in ghostremaster must conform to this pipeline structure.
