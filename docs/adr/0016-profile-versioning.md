# ADR-0016: Profile Format Versioning

## Status
Accepted

## Context
ghostremaster profiles define how a system is reconstructed into an ISO. These profiles will evolve over time as features are added.

Without versioning:
- Old profiles may break silently
- Rebuild results may become inconsistent
- Schema changes could destroy reproducibility

We need a controlled evolution strategy.

## Decision
We will introduce explicit versioning in all profile outputs.

### 1. Required field

Every profile must include:

version: integer

Example:
version: 1

### 2. Compatibility rule

- Backward compatibility is required for at least one major version
- Forward compatibility is not guaranteed
- Unknown fields must be ignored, not rejected

### 3. Upgrade mechanism

If a profile is outdated, ghostremaster will:

- Detect version mismatch
- Apply a migration step if available
- Otherwise warn and halt execution

## Consequences

### Positive
- Enables safe long-term evolution
- Prevents silent corruption of rebuilds
- Allows iterative improvement of format

### Negative
- Requires migration logic maintenance
- Adds complexity to parsing layer
