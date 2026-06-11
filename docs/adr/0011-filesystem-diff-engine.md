# ADR-0011: Filesystem Diff Engine Design

## Status
Accepted

## Context
ghostremaster must detect exactly what changed between:

- A baseline GhostBSD system (extracted from official ISO)
- A customized live system (user-modified state)

This includes:
- Installed packages
- Configuration changes
- Desktop environment customization
- User-level modifications
- System-level configuration changes

We must avoid:
- Capturing temporary runtime state
- Capturing system noise (logs, caches, ephemeral files)
- Misclassifying unchanged system files as modified

A correct diff engine is the core requirement for reproducible ISO generation.

## Decision
We will implement a deterministic filesystem diff engine with the following rules:

### 1. Baseline comparison model
The diff engine compares two rooted filesystem trees:

- BASE: extracted GhostBSD ISO filesystem
- LIVE: current system state (mounted root or staged snapshot)

Comparison is performed file-by-file using absolute paths relative to root.

---

### 2. File classification rules

Each path is classified as one of:

- ADDED: exists in LIVE but not in BASE
- DELETED: exists in BASE but not in LIVE
- MODIFIED: exists in both but content differs
- UNCHANGED: ignored

---

### 3. Comparison method

File equality is determined in the following order:

1. If file type differs → MODIFIED
2. If size differs → MODIFIED
3. If SHA256 hash differs → MODIFIED
4. Otherwise → UNCHANGED

Metadata-only differences (such as timestamps) are ignored unless explicitly enabled.

---

### 4. Directory handling

- Directories are traversed recursively
- Empty directories are preserved only if explicitly required
- Symlinks are preserved but not dereferenced during hashing

---

### 5. Exclusion rules

The following paths are always excluded:

- /dev
- /proc
- /tmp
- /var/tmp
- /var/run
- /media
- /mnt
- system logs under /var/log
- package cache directories

Additionally, user-defined ignore rules may be applied.

---

### 6. Home directory policy

By default:

- ~/.config → INCLUDED
- ~/.local → INCLUDED
- ~/.themes → INCLUDED if present
- ~/.icons → INCLUDED if present
- Downloads and browser cache → EXCLUDED

This ensures personalization is preserved without capturing sensitive or unnecessary data.

---

### 7. Output format

The diff engine produces a structured output:

- added.txt
- modified.txt
- deleted.txt
- optional: file blobs for modified/added files

Paths are stored relative to filesystem root.

Example:

added:
  /home/user/.config/xfce4/panel.xml

modified:
  /etc/rc.conf

deleted:
  /usr/local/share/old-theme

---

### 8. Performance model

- Files are streamed, not fully loaded into memory
- Hash computation is chunked (streaming SHA256)
- Directory traversal is iterative to avoid recursion limits

Target systems include live USB environments with limited memory.

---

## Consequences

### Positive
- Deterministic and reproducible system capture
- Accurate reconstruction of user environment
- Compatible with ISO-based remastering workflow
- Works without requiring installation of ghostbsd-build

### Negative
- Computationally expensive on large filesystems
- Requires careful tuning of exclusion rules
- Must be validated across GhostBSD version changes
- Edge cases in device files and special filesystems must be handled carefully

## Notes
This ADR defines the most critical subsystem of ghostremaster. All future ISO generation, overlay creation, and profile export functionality depends on the correctness of this diff engine.
