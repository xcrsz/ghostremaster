# ADR-0006: Configuration Capture Scope

## Status
Accepted

## Context
We must define what user data is included in a remaster.

## Decision

### Included:
- ~/.config
- ~/.local
- ~/.themes
- ~/.icons
- Selected /etc entries
- Selected /usr/local/etc entries

### Excluded:
- Downloads
- Caches
- Logs
- Browser cookies (default)
- /var

## Consequences
- Prevents accidental leakage of sensitive data
- Requires ignore-rule system
- May require future user opt-in expansion
