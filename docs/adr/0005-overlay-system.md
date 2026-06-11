# ADR-0005: Overlay System Design

## Status
Accepted

## Context
User modifications must be applied to the ISO filesystem.

## Decision
We use a filesystem overlay structure:

overlay/
├── etc/
├── usr/
├── home/
└── root/

These files are copied onto the extracted ISO filesystem during build.

## Consequences
- Simple and predictable model
- Risk of overwriting base system files
- Future need for conflict-resolution logic
