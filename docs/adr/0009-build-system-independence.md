# ADR-0009: Independence from ghostbsd-build

## Status
Accepted

## Context
GhostBSD already provides `ghostbsd-build` for official ISO creation.

## Decision
We will NOT use `ghostbsd-build`.

Instead:
- Treat GhostBSD ISO as a static base artifact
- Modify extracted ISO directly
- Rebuild independently using FreeBSD tooling

## Consequences
- Full control over pipeline
- Risk of future ISO format drift
- Requires version compatibility tracking
