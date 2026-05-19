# Dotfiles Agent Rules

## Goal

Minimize manual dotfiles tinkering.

The user should mostly ask for outcomes, not edit installers, sync scripts, or migration logic manually.

## Supported platforms

- Windows 11 with native Git Bash
- Debian Trixie
- Arch/CachyOS

Unsupported:
- WSL
- Cygwin
- MSYS2 outside Git Bash unless explicitly added

## General rules

- No third-party dotfiles manager.
- No WSL support.
- No `.sh` extensions for Bash executables.
- All Bash must pass ShellCheck.
- Use strict JSON only.
- Use `jq` for JSON parsing in Bash.
- Prefer XDG/Open Desktop paths where possible.
- Use XDG-style variables internally on all platforms.
- Use native application paths externally when required.
- Do not use symlinks.
- Do not use hardlinks.
- Use copy plus hash-based state tracking.
- Generated scripts should not be hand-edited.
- Shared agent skills belong under `config/agents/skills/<name>/SKILL.md` and deploy to `${HOME}/.agents/skills/<name>/SKILL.md`.

## Intentional XDG exceptions

`~/.agents/skills/<name>/SKILL.md` is allowed as an intentional XDG exception because the shared agent skill discovery convention is home-based.

Prefer XDG paths everywhere else unless the external application requires a native path.

## Profiles

- `minimal` contains the smallest cross-platform baseline needed to operate the system.
- `developer` extends `minimal` with optional workflow enhancements.

## Tool policy

Prefer cross-platform tools.

Avoid adding different tools for the same use case per platform unless explicitly justified.

Prefer standalone binaries over runtime-based installers.

Avoid adding Node.js, Python, Java, Ruby, Rust, etc. unless directly required.

Prefer:
- GitHub release binaries
- native packages
- self-contained installers

Avoid by default:
- global npm installs
- cargo install
- pip installs

Core Unix tooling remains canonical knowledge.

Modern tools should enhance workflows, not replace foundational understanding.

When adding a new tool to `spec.json`, also add a matching installer at `generated/installers/<tool-name>`.

`generated/doctor` must enforce installer coverage for all tools defined in `spec.json`.

## Authentication policy

Prefer tool-native authentication over secret management.

The dotfiles system manages configuration and tooling, not user credentials.

KeePassXC is treated as a user-managed vault, not a secret broker.

## Secrets

Never commit:
- private keys
- tokens
- credentials
- shell history
- cloud credentials
- `.env` files

If unsure whether a file contains secrets, do not import it automatically.

## Git ignore management

The agent may manage `.gitignore`.

Prefer preventing accidental commits over convenience.

## Sync safety

Only overwrite managed files.

Never delete unmanaged files.

Require:
inspect -> plan -> diff -> validate -> approval -> apply

## Stability and maintenance policy

Prefer boring stability over endless optimization.

The system is intended to be long-lived, understandable, and maintainable.

Do not add tools, abstractions, automation, or workflows unless they provide clear long-term value.

Every added dependency becomes permanent maintenance burden.
