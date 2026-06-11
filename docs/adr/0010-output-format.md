# ADR-0010: Output Artifact Format

## Status
Accepted

## Context
We must define a reproducible capture format.

## Decision
We define a profile directory:

profile/
├── manifest.json
├── packages.txt
├── filesystem.delta
├── overlay/
└── metadata.json

This directory is the single source of truth for ISO reconstruction.

## Consequences
- Fully version-controlled format
- Portable across systems
- Requires schema evolution policy
