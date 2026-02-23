# skill-manager

A Claude Code plugin to manage global skills. List, enable, disable, and inspect skills from within Claude Code or the terminal.

## Why

Claude Code loads every skill in `~/.claude/skills/` on every session. As you install more skills, the context grows and irrelevant skills can slow things down or cause confusion. There is no built in way to selectively control which skills are active ([#19922](https://github.com/anthropics/claude-code/issues/19922), [#22894](https://github.com/anthropics/claude-code/issues/22894)).

skill-manager gives you granular control. Disable what you do not need, enable it when you do. Skills are moved between `~/.claude/skills/` (active) and `~/.claude/skills-disabled/` (parked). Nothing is deleted.

## Install

### As a Claude Code Plugin

```bash
claude plugin install valllabh/skill-manager
```

### Manual (local development)

```bash
git clone https://github.com/valllabh/skill-manager.git
cd skill-manager
claude plugin install --local .
```

## Uninstall

```bash
claude plugin uninstall skill-manager
```

## Usage

### Inside Claude Code

Use the `/skill-manager` slash command:

```
/skill-manager              Interactive mode (numbered list, pick to toggle)
/skill-manager list         Show all skills with status
/skill-manager info <name>  Show details about a specific skill
/skill-manager enable <n>   Enable skill(s) by name
/skill-manager disable <n>  Disable skill(s) by name
```

### Terminal

Run the script directly:

```bash
bash skills/skill-manager/scripts/skill-manager.sh list
bash skills/skill-manager/scripts/skill-manager.sh info jira-create
bash skills/skill-manager/scripts/skill-manager.sh enable jira-create
bash skills/skill-manager/scripts/skill-manager.sh disable jira-create jira-get
```

## How it works

| Directory | Purpose |
|---|---|
| `~/.claude/skills/` | Active skills loaded by Claude Code |
| `~/.claude/skills-disabled/` | Parked skills, invisible to Claude Code |

Disabling a skill moves its folder to `skills-disabled/`. Enabling moves it back. No files are deleted.

## Scope and Limitations

skill-manager operates on **global skills** in `~/.claude/skills/` only.

Not currently supported:
- Plugin bundled skills (skills inside `~/.claude/plugins/`)
- Workspace level skills (project local `.claude/skills/`)
- Skill conflict detection when the same name exists in multiple locations

These are tracked upstream and may be addressed in future versions.

## Project Structure

```
skill-manager/
  .claude-plugin/
    plugin.json              Plugin manifest
  skills/
    skill-manager/
      SKILL.md               Skill definition
      scripts/
        skill-manager.sh     Management script
  README.md
  LICENSE
  CHANGELOG.md
```

## License

MIT
