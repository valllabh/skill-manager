---
name: skill-manager
description: Manage global Claude Code skills. Use when the user says "skill-manager", "manage skills", "list skills", "disable skill", "enable skill", "skill info", or wants to enable, disable, inspect, or list Claude Code skills.
version: 1.3.0
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

IMPORTANT: The script has an interactive mode that uses stdin, which does NOT work inside Claude Code's Bash tool. Never run the script without arguments or with just `enable`/`disable` (no names). Always use the explicit name based commands.

## Flow for all requests

### `/skill-manager` or `/skill-manager list`
Run: `bash "{base_directory}/scripts/skill-manager.sh" list`
Show the output to the user.

### `/skill-manager info <name>`
Run: `bash "{base_directory}/scripts/skill-manager.sh" info <name>`
Show the output to the user.

### `/skill-manager enable` (no names given)
1. Run: `bash "{base_directory}/scripts/skill-manager.sh" list`
2. Show the list to the user
3. Ask the user which disabled skills (marked with empty circle) they want to enable
4. Run: `bash "{base_directory}/scripts/skill-manager.sh" enable <name1> <name2> ...`

### `/skill-manager enable <names>`
Run: `bash "{base_directory}/scripts/skill-manager.sh" enable <names>`

### `/skill-manager disable` (no names given)
1. Run: `bash "{base_directory}/scripts/skill-manager.sh" list`
2. Show the list to the user
3. Ask the user which enabled skills (marked with filled circle) they want to disable
4. Run: `bash "{base_directory}/scripts/skill-manager.sh" disable <name1> <name2> ...`

### `/skill-manager disable <names>`
Run: `bash "{base_directory}/scripts/skill-manager.sh" disable <names>`

Always show script output directly to the user.
