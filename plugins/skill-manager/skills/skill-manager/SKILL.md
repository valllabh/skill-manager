---
name: skill-manager
description: Manage global Claude Code skills. Use when the user says "skill-manager", "manage skills", "list skills", "disable skill", "enable skill", "skill info", or wants to enable, disable, inspect, or list Claude Code skills.
version: 1.0.0
license: MIT
---

# Skill Manager

Manage global Claude Code skills by listing, enabling, disabling, and inspecting them.

## How it works

Moves skill folders between `~/.claude/skills/` (active) and `~/.claude/skills-disabled/` (disabled). Changes take effect on the next Claude Code session.

## Instructions

The management script is located at `scripts/skill-manager.sh` relative to this SKILL.md file.

Run the script using the Bash tool based on the user's request:

| User Request | Command |
|---|---|
| `/skill-manager` or no args | `bash <PLUGIN_DIR>/skills/skill-manager/scripts/skill-manager.sh` |
| `/skill-manager list` | `bash <PLUGIN_DIR>/skills/skill-manager/scripts/skill-manager.sh list` |
| `/skill-manager info <name>` | `bash <PLUGIN_DIR>/skills/skill-manager/scripts/skill-manager.sh info <name>` |
| `/skill-manager enable <names>` | `bash <PLUGIN_DIR>/skills/skill-manager/scripts/skill-manager.sh enable <names>` |
| `/skill-manager disable <names>` | `bash <PLUGIN_DIR>/skills/skill-manager/scripts/skill-manager.sh disable <names>` |

Where `<PLUGIN_DIR>` is the directory containing the `.claude-plugin/` folder. Resolve this by finding the `scripts/skill-manager.sh` file relative to this SKILL.md file's location.

Always show the output directly to the user.
