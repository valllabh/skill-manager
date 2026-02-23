---
name: skill-manager
description: Manage global Claude Code skills. Use when the user says "skill-manager", "manage skills", "list skills", "disable skill", "enable skill", "skill info", or wants to enable, disable, inspect, or list Claude Code skills.
version: 1.2.0
license: MIT
allowed-tools: Bash
---

# Skill Manager

Manage global Claude Code skills by listing, enabling, disabling, and inspecting them.

## How it works

Moves skill folders between `~/.claude/skills/` (active) and `~/.claude/skills-disabled/` (disabled). Changes take effect on the next Claude Code session.

## Instructions

When this skill is loaded, a "Base directory for this skill" path is provided. The script is at `scripts/skill-manager.sh` inside that base directory.

Construct the full script path as: `{base_directory}/scripts/skill-manager.sh`

Run the script using the Bash tool. Pass arguments based on the user's request:

- `/skill-manager` (no args): `bash "{base_directory}/scripts/skill-manager.sh"`
- `/skill-manager list`: `bash "{base_directory}/scripts/skill-manager.sh" list`
- `/skill-manager info <name>`: `bash "{base_directory}/scripts/skill-manager.sh" info <name>`
- `/skill-manager enable`: `bash "{base_directory}/scripts/skill-manager.sh" enable`
- `/skill-manager enable <names>`: `bash "{base_directory}/scripts/skill-manager.sh" enable <names>`
- `/skill-manager disable`: `bash "{base_directory}/scripts/skill-manager.sh" disable`
- `/skill-manager disable <names>`: `bash "{base_directory}/scripts/skill-manager.sh" disable <names>`

Always show the output directly to the user.
