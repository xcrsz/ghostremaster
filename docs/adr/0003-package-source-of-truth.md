# ADR-0003: Package Source of Truth

## Status
Accepted

## Context
We need a reliable and deterministic way to reproduce the set of installed software in a GhostBSD system.

Inferring installed software from the filesystem is unreliable because:
- Files may be shared between packages
- Manual installations can be indistinguishable from packaged files
- File presence does not guarantee package ownership

We need a canonical source of truth.

## Decision
We will use the FreeBSD package database as the authoritative source of installed software.

The installed package list will be retrieved using:

pkg query %n

This output defines the full set of explicitly installed packages for the system profile.

## Consequences
- The rebuild process depends on pkg being available and functional
- Package repositories must remain compatible with the GhostBSD version used for rebuilding
- The resulting ISO will be reproducible at the package level, independent of filesystem state
