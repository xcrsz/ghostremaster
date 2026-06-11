# ADR-0008: Implementation Language

## Status
Accepted

## Context
We need a system-level implementation language.

## Decision
We will use **Zig**.

## Rationale:
- Static binary output (no runtime dependency)
- Direct system calls
- Good fit for filesystem tooling
- Easy integration with FreeBSD utilities

## Consequences
- Smaller ecosystem than Rust/Python
- More low-level implementation required
- Higher initial development effort
