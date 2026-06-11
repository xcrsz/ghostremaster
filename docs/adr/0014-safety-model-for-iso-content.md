# ADR-0014: Safety Model for ISO Content Inclusion

## Status
Accepted

## Context
The remastered ISO may unintentionally include:

- Sensitive user data
- Credentials
- SSH keys
- Browser profiles
- Temporary system state

We must define strict rules for what is allowed inside a generated ISO.

## Decision
We define a **default-deny sensitive data model**.

### 1. Never include automatically

The following are always excluded:

- SSH private keys (`~/.ssh/id_*`)
- Browser cookies and session storage
- Password databases
- Temporary directories
- System logs
- Package caches
- Swap or memory dumps

### 2. Conditionally included data

The following require explicit opt-in:

- Documents directory
- Downloads directory
- Browser profiles
- Email clients data
- Virtual machine images

### 3. Always safe to include

The following are safe by default:

- `~/.config`
- `~/.local`
- Themes and icons
- Desktop environment settings
- Installed package metadata

## Consequences

### Positive
- Prevents accidental leakage of sensitive information
- Makes generated ISOs safe for redistribution
- Encourages reproducible system definitions

### Negative
- Requires user prompts or configuration flags
- Increases complexity of capture logic
- Risk of false negatives if ignore rules are incomplete
