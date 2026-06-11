# ADR-0019: Reproducibility and Determinism Guarantees

## Status
Accepted

## Context
A core goal of ghostremaster is reproducibility:

- Same profile → same ISO output
- Builds must be deterministic
- Outputs must be verifiable

Without strict determinism, remastered ISOs become untrustworthy.

## Decision
We enforce deterministic build rules:

### 1. File ordering

- All directory listings are sorted before processing
- No reliance on filesystem order

### 2. Timestamp normalization

- File timestamps are ignored unless explicitly required
- ISO build timestamps are normalized

### 3. Hash-based verification

- All modified/added files are validated using SHA256

### 4. Environment normalization

- Build process ignores host system locale variations
- PATH ordering is fixed internally

### 5. No hidden state

- Build output depends only on:
  - profile/
  - base ISO
  - explicit configuration

## Consequences

### Positive
- Fully reproducible ISO builds
- Easier debugging and auditing
- Enables caching and CI builds

### Negative
- Requires strict control over environment
- Some system-specific behaviors must be normalized manually
