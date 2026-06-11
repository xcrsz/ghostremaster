# ADR-0017: Conflict Resolution Rules (Overlay vs Base System)

## Status
Accepted

## Context
During ISO reconstruction, multiple sources may define conflicting file states:

- Base GhostBSD ISO files
- Diff modifications (ADR-0011)
- Overlay layer (ADR-0005)

We must define deterministic resolution rules.

## Decision
We define a strict priority order:

1. Overlay layer (highest priority)
2. Diff modifications
3. Base ISO filesystem (lowest priority)

### 1. File conflict rule

If a file exists in multiple layers:

- The highest priority layer wins completely
- No merging of file contents occurs (except future explicit formats)

### 2. Directory conflict rule

- Directories are merged recursively
- File-level rules apply inside directories

### 3. Deletion rule

If a file is marked as deleted in diff:

- It is removed even if present in base ISO
- Overlay cannot resurrect deleted files unless explicitly re-added

## Consequences

### Positive
- Predictable deterministic builds
- Simple mental model
- Easy to debug reconstruction issues

### Negative
- No automatic merging of configs
- Risk of overwriting base system files unintentionally
