---
name: dotfiles
description: Maintain, inspect, update, onboard, sync, validate, and repair this user's cross-platform dotfiles repository. Use when working with spec.json, AGENTS.md, config/**, generated scripts, profiles, tool lifecycle, onboarding, shellcheck, jq, or dotfiles sync safety.
---

# Dotfiles Skill

Use this skill when the user asks to maintain, inspect, update, onboard, sync, repair, or reason about their dotfiles repository.

## Purpose

Help maintain a stable, cross-platform, agent-managed dotfiles setup.

The user wants minimal tinkering. Prefer safe repo changes, generated scripts, validation, and diffs over manual instructions.

## Repository contract

Expected layout:

```text
AGENTS.md
spec.json
schema/spec.schema.json
config/**
generated/**
state/state.json
.gitignore
```

Ownership:

- `spec.json`: structured source of truth
- `config/**`: managed config files, including shared agent skills
- `generated/**`: generated executables and helper scripts
- `state/state.json`: machine-written sync state
- `AGENTS.md`: operating policy
- `.gitignore`: agent-managed safety net

Do not hand-edit generated scripts unless the user explicitly asks. Prefer editing `spec.json`, `config/**`, or `AGENTS.md`, then regenerating.

## Supported platforms

- Windows 11 with native Git Bash
- Debian Trixie
- Arch/CachyOS

Unsupported:

- WSL
- Cygwin
- MSYS2 outside Git Bash unless explicitly added

## Core rules

- No third-party dotfiles manager.
- Use strict JSON only.
- Use `jq` for JSON parsing in Bash.
- Bash executables have no `.sh` extension.
- All Bash must pass ShellCheck.
- No symlinks.
- No hardlinks.
- Use copy plus hash-based state tracking.
- Require plan before apply.
- Never delete unmanaged files.
- Never overwrite unmanaged local changes.
- Prefer XDG/Open Desktop paths.
- Use native application paths externally when required.
- Prefer cross-platform tools.
- Be critical of platform-specific alternatives for the same use case.
- Prefer boring stability over endless optimization.

## Shared skill location

This skill is managed as a shared agent skill:

```text
config/agents/skills/dotfiles/SKILL.md
```

It should be deployed to:

```text
${HOME}/.agents/skills/dotfiles/SKILL.md
```

This is an intentional XDG exception because the shared agent skill convention is home-based.

Do not place this skill under `.chatgpt/skills`.

Use OpenCode-specific skill locations only for OpenCode-specific behavior.

## Tool policy

Minimal profile should contain only the cross-platform baseline needed to operate and validate the system.

Developer profile may contain workflow enhancements.

Before adding a tool, evaluate:

- Does it solve a recurring problem?
- Does it work cross-platform?
- Does it reduce overall complexity?
- Does it improve long-term maintainability?
- Can existing tooling already solve the problem adequately?

Prefer standalone binaries or native packages. Avoid adding language runtimes unless directly required.

## Authentication and secrets

The dotfiles system manages configuration and tooling, not credentials.

Prefer tool-native authentication:

- `gh auth status`, then `gh auth login`
- `ssh-add -l`, then ask user to add keys
- tool-native login flows for other CLIs

KeePassXC is allowed as a developer tool and user-managed vault, but not as the normal automation secret broker.

Never commit or import:

- private keys
- tokens
- credentials
- shell history
- cloud credentials
- `.env` files
- machine-local caches

If unsure whether a file contains secrets, do not import it automatically.

## Using generated scripts

When generated scripts exist, use them as the operational interface.

Preferred sequence:

```bash
generated/doctor
generated/plan
generated/sync
```

Safety sequence:

```text
inspect -> plan -> diff -> validate -> approval -> apply
```

Do not run an apply/sync action that mutates user files unless a plan has been generated first or the user explicitly asks for direct application.

If a generated script is missing, propose or create it from `spec.json` rather than inventing ad-hoc commands.

## Generated command expectations

Generated commands should be extensionless Bash executables:

```text
generated/onboard
generated/plan
generated/sync
generated/doctor
```

Expected behavior:

- `onboard`: inspect current setup and propose imports
- `plan`: compare desired vs actual and show safe actions
- `sync`: apply approved changes
- `doctor`: validate environment, schema, ShellCheck, secret safety, and consistency

## Validation

Before finalizing repo changes, run or recommend:

```bash
jq empty spec.json
generated/doctor
```

If ShellCheck is available:

```bash
shellcheck generated/*
```

Never claim validation passed unless it actually ran.
