# ghostremaster

**Remaster a customized GhostBSD system into a bootable ISO — with a single command.**

`ghostremaster` is a standalone, dependency-free tool that captures the state of a
running GhostBSD system (packages, configuration, and user customization) and
rebuilds a bootable, redistributable ISO that reproduces that exact system. It is
written in [Zig](https://ziglang.org/) and relies only on FreeBSD-native tooling
(`pkg`, `makefs`, `mkimg`, `mount_cd9660`) — it does **not** depend on
`ghostbsd-build`.

> **Project status: early / pre-alpha.** The architecture is fully specified across
> 19 accepted ADRs (see [`docs/adr/`](docs/adr/)), but most subsystems are still
> skeletons. This README also defines a **milestone-based funding plan** so donors
> know exactly what each contribution unlocks. See [Roadmap & Funding](#roadmap--funding-goals).

---

## Why

GhostBSD ships no native tool for turning a customized live or installed system back
into an installable ISO. The official `ghostbsd-build` pipeline targets *official OS
builds*, not user-driven system capture. `ghostremaster` fills that gap:

1. Boot a GhostBSD live ISO (or use an installed system).
2. Install packages and customize the desktop, configs, and themes.
3. Run `ghostremaster capture` then `ghostremaster build`.
4. Get a bootable ISO identical to your customized system state.

This enables reproducible spins, personal recovery images, classroom/lab images, and
community remasters — all from a profile directory that is fully version-controllable.

---

## How it works

`ghostremaster` uses a **diff-based capture model** rather than a noisy full clone:

```
 ┌────────────┐    extract     ┌──────────────┐
 │ Official   │ ────────────▶ │ BASE rootfs  │
 │ GhostBSD   │                │ (read-only)  │
 │ ISO        │                └──────┬───────┘
 └────────────┘                       │  diff (ADR-0011)
                                      ▼
 ┌────────────┐    capture     ┌──────────────┐    assemble     ┌──────────────┐
 │ LIVE       │ ────────────▶ │ profile/     │ ─────────────▶ │ Bootable ISO │
 │ customized │                │ (source of   │   (ADR-0012)    │ (BIOS+UEFI)  │
 │ system     │                │  truth)      │                 └──────────────┘
 └────────────┘                └──────────────┘
```

The captured **profile** is the single source of truth for reconstruction
(ADR-0010):

```
profile/
├── manifest.json       # what changed (added/modified/deleted)
├── packages.txt        # `pkg query %n` — authoritative package set
├── filesystem.delta    # diff output relative to base ISO
├── overlay/            # files copied verbatim onto the ISO rootfs
└── metadata.json       # versioned profile metadata
```

The full transformation pipeline (extract → apply diff → apply overlay → rebuild
rootfs image → integrate boot → rebuild ISO → validate) is specified in
[ADR-0012](docs/adr/0012-iso-assembly-pipeline.md).

### Design principles

- **Diff, don't clone** — capture only real changes; ignore `/dev`, `/proc`, caches,
  logs (ADR-0002, ADR-0011).
- **Default-deny on sensitive data** — SSH keys, cookies, password stores, and swap
  are never captured automatically; documents/downloads/browser profiles are opt-in
  (ADR-0014).
- **Deterministic & reproducible** — sorted traversal, normalized timestamps, SHA256
  verification; same profile + same base ISO → same ISO (ADR-0019).
- **Portable output** — a first-boot init system regenerates host keys, hostname, and
  network identity so images are safe to redistribute (ADR-0015).
- **No external build system** — modify an extracted official ISO in place and rebuild
  with FreeBSD tooling only (ADR-0004, ADR-0009).

---

## Architecture & decisions (ADRs)

All design decisions are recorded as Architecture Decision Records in
[`docs/adr/`](docs/adr/):

| ADR | Topic |
| --- | ----- |
| [0001](docs/adr/0001-core-goals.md) | Core goal of ghostremaster |
| [0002](docs/adr/0002-capture-strategy.md) | Capture strategy (diff vs full clone) |
| [0003](docs/adr/0003-package-source-of-truth.md) | Package source of truth (`pkg`) |
| [0004](docs/adr/0004-iso-rebuild-strategy.md) | ISO rebuild strategy |
| [0005](docs/adr/0005-overlay-system.md) | Overlay system design |
| [0006](docs/adr/0006-capture-scope.md) | Configuration capture scope |
| [0007](docs/adr/0007-diff-engine.md) | Filesystem diff engine |
| [0008](docs/adr/0008-language-choice.md) | Implementation language (Zig) |
| [0009](docs/adr/0009-build-system-independence.md) | Independence from `ghostbsd-build` |
| [0010](docs/adr/0010-output-format.md) | Output artifact format (profile/) |
| [0011](docs/adr/0011-filesystem-diff-engine.md) | Filesystem diff engine design (core) |
| [0012](docs/adr/0012-iso-assembly-pipeline.md) | ISO assembly pipeline |
| [0013](docs/adr/0013-boot-environment-and-live-detection.md) | Boot environment & live detection |
| [0014](docs/adr/0014-safety-model-for-iso-content.md) | Safety model for ISO content |
| [0015](docs/adr/0015-first-boot-initialization-system.md) | First-boot initialization |
| [0016](docs/adr/0016-profile-versioning.md) | Profile format versioning |
| [0017](docs/adr/0017-conflict-resolution-rules.md) | Conflict resolution (overlay vs base) |
| [0018](docs/adr/0018-performance-model.md) | Performance model & scalability |
| [0019](docs/adr/0019-reproducibility-and-determinism.md) | Reproducibility & determinism |

---

## Building

Requires a recent Zig toolchain. On GhostBSD/FreeBSD:

```sh
pkg install zig
zig build
```

The binary is produced at `zig-out/bin/ghostremaster`.

## Usage

```sh
# Capture the current system into ./profile
ghostremaster capture

# Rebuild a bootable ISO from the captured profile
ghostremaster build
```

> Runtime tooling expected on the target (GhostBSD): `pkg`, `makefs`, `mkimg`,
> `mdconfig`, `mount_cd9660`.

---

## Implementation status

| Subsystem | ADR | Status |
| --------- | --- | ------ |
| CLI scaffolding (`capture`/`build`) | — | ⚙️ Minimal |
| Package capture (`pkg query %n`) | 0003 | ✅ Working |
| SHA256 file hashing | 0011/0018 | ✅ Working |
| Profile schema & versioning | 0010/0016 | 🔲 Stub |
| Filesystem diff engine | 0011 | 🔲 Stub |
| ISO extraction | 0012 | 🔲 Stub |
| Overlay + conflict resolution | 0005/0017 | 🔲 Stub |
| Safety / sensitive-data model | 0014 | 🔲 Not started |
| ISO assembly (makefs/mkimg) | 0012 | 🔲 Stub |
| First-boot init system | 0015 | 🔲 Not started |
| Reproducibility & validation | 0019 | 🔲 Not started |

✅ working · ⚙️ partial · 🔲 not implemented

---

## Roadmap & Funding Goals

`ghostremaster` is community-funded free software. The work is broken into **seven
milestones**, each with a concrete deliverable and a **donation goal that must be met
before that milestone's work begins**. Funding a milestone is what unlocks it: when a
goal is reached, that block of work is scheduled, built in the open, and released
before the next goal opens.

### Estimation basis

These figures are a transparent, bottom-up estimate — not a fixed quote. Assumptions:

- **Effort** is estimated in developer-days for one experienced Zig + FreeBSD systems
  developer, including design, implementation, tests, and documentation.
- **Rate:** **$50 / hour**, **8 hours / day** → **$400 / developer-day**. This is a
  discounted community/FOSS contract rate (commercial systems work typically runs
  2–3× higher).
- Goals are rounded to clean numbers to serve as motivating donation targets. They
  cover labor only; CI, signing, and test-hardware costs are folded into Milestone 7.
- Estimates assume the GhostBSD ISO layout remains stable; major upstream layout
  changes may require re-scoping.

### Milestones

| # | Milestone | Scope (ADRs) | Effort | Funding goal |
| - | --------- | ------------ | -----: | -----------: |
| **M1** | **Foundation & profile format** | CLI hardening, profile schema, manifest/metadata serialization, versioning & migration (0010, 0016) | 10 days | **$4,000** |
| **M2** | **Filesystem diff engine** *(core)* | Iterative traversal, streaming SHA256, add/modify/delete classification, exclusion rules, symlink handling (0007, 0011, 0018) | 20 days | **$8,000** |
| **M3** | **ISO extraction & environment detection** | `mdconfig`/`mount_cd9660` orchestration, base-ISO extraction, live vs installed detection (0012 Phase 1, 0013) | 12 days | **$5,000** |
| **M4** | **Overlay, conflict resolution & safety model** | Overlay merge, strict priority rules, deletion handling, default-deny sensitive-data filtering & opt-in flags (0005, 0014, 0017) | 12 days | **$5,000** |
| **M5** | **ISO assembly pipeline** | Apply diff+overlay to rootfs, `makefs` image build, boot integration (BIOS+UEFI), CD9660 ISO generation (0004, 0012 Phases 2–6) | 25 days | **$10,000** |
| **M6** | **First-boot initialization system** | rc.d hook, host-key/hostname/network regeneration, idempotent run-once logic (0015) | 10 days | **$4,000** |
| **M7** | **Reproducibility, validation & 1.0 release** | Determinism guarantees, automated VM boot/install validation, packaging, docs, CI & test hardware (0012 Phase 7, 0019) | 15 days | **$6,000** |
| | **Total** | | **104 days** | **$42,000** |

### What "completion" looks like

- **After M1–M2:** `ghostremaster capture` produces a complete, versioned, accurate
  profile of a customized system — the hardest correctness problem, solved.
- **After M3–M5:** `ghostremaster build` produces a real, bootable, installable ISO on
  both BIOS and UEFI — the tool is end-to-end usable.
- **After M6–M7:** generated ISOs are safe to redistribute and builds are reproducible
  and validated — a trustworthy **1.0**.

> **Timeline note:** 104 developer-days is roughly **3.5 months** of full-time work, or
> about **5–6 months** part-time. Funding velocity sets the actual pace — milestones
> are sequential because each depends on the previous one.

### Supporting the project

Donations are tracked against the goals above, and progress is reported per milestone
in the open. *(Donation links — e.g. GitHub Sponsors / OpenCollective / Liberapay —
to be added here once set up.)*

If you represent an organization that depends on GhostBSD and wants a specific
milestone prioritized or accelerated, sponsorship inquiries are welcome via the
project maintainers.

---

## Contributing

Issues, design feedback on the ADRs, and patches are welcome. Because the diff engine
(ADR-0011) and assembly pipeline (ADR-0012) are the architectural backbone, please read
the relevant ADRs before proposing changes to those areas.

## License

TBD — a permissive BSD-style license (consistent with the GhostBSD/FreeBSD ecosystem)
is planned.
