# ADR-0002: Capture Strategy (Diff vs Full Clone)

## Status
Accepted

## Context
We must capture user modifications reliably.

Two approaches exist:

1. Full filesystem clone (simple but noisy and unsafe)
2. Differential capture against base GhostBSD ISO (precise but complex)

## Decision
We will use a **diff-based capture model**:

- Extract original GhostBSD ISO filesystem as baseline
- Compare live system against baseline
- Record:
  - Added files
  - Modified files
  - Deleted files

## Consequences
- Requires ISO extraction step
- Requires deterministic comparison engine
- Avoids capturing system noise (`/dev`, `/proc`, caches)
