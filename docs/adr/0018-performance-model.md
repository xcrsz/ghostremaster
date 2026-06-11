# ADR-0018: Performance Model and Scalability Constraints

## Status
Accepted

## Context
ghostremaster must operate on full GhostBSD systems, potentially including:

- Large filesystem trees
- Thousands of installed files
- High I/O workloads during hashing and diffing

We must ensure the tool remains usable on:

- Live USB environments
- Systems with limited RAM
- Slow storage devices

## Decision
We define the following performance constraints:

### 1. Streaming-first design

- Files are processed in streams, not fully loaded into memory
- Large files are hashed incrementally

### 2. Iterative traversal

- No recursive stack-based directory traversal
- Use explicit iteration to avoid stack overflow

### 3. Hashing strategy

- SHA256 used for integrity checks
- Chunked reads (e.g., 64KB blocks)

### 4. Parallelism (optional future feature)

- Diff operations may be parallelized
- ISO build remains mostly sequential for safety

## Consequences

### Positive
- Works on low-resource systems
- Predictable memory usage
- Safe for live environments

### Negative
- Slower than aggressive parallel implementations
- More complex I/O scheduling logic required later
