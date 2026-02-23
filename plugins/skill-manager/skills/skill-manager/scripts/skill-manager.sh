#!/bin/bash
# skill-manager: Manage global Claude Code skills
# https://github.com/valllabh/skill-manager

SKILLS_DIR="$HOME/.claude/skills"
DISABLED_DIR="$HOME/.claude/skills-disabled"

mkdir -p "$SKILLS_DIR" "$DISABLED_DIR"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

VERSION="1.0.0"

load_skills() {
    ALL_SKILLS=()
    ALL_STATUSES=()

    for dir in "$SKILLS_DIR"/*/; do
        [ -d "$dir" ] || continue
        ALL_SKILLS+=("$(basename "$dir")")
        ALL_STATUSES+=("enabled")
    done

    for dir in "$DISABLED_DIR"/*/; do
        [ -d "$dir" ] || continue
        ALL_SKILLS+=("$(basename "$dir")")
        ALL_STATUSES+=("disabled")
    done

    # Sort by name
    local indices=($(for i in "${!ALL_SKILLS[@]}"; do echo "$i ${ALL_SKILLS[$i]}"; done | sort -k2 | awk '{print $1}'))

    SORTED_SKILLS=()
    SORTED_STATUSES=()
    for i in "${indices[@]}"; do
        SORTED_SKILLS+=("${ALL_SKILLS[$i]}")
        SORTED_STATUSES+=("${ALL_STATUSES[$i]}")
    done
}

# Display skills filtered by mode: all, enabled, disabled
display_skills() {
    local filter="$1"  # all, enabled, disabled

    load_skills

    if [ ${#SORTED_SKILLS[@]} -eq 0 ]; then
        echo ""
        echo "No skills found."
        echo ""
        return 1
    fi

    # Build filtered list
    DISPLAY_SKILLS=()
    DISPLAY_STATUSES=()
    DISPLAY_INDICES=()

    for i in "${!SORTED_SKILLS[@]}"; do
        if [ "$filter" = "all" ] || [ "$filter" = "${SORTED_STATUSES[$i]}" ]; then
            DISPLAY_SKILLS+=("${SORTED_SKILLS[$i]}")
            DISPLAY_STATUSES+=("${SORTED_STATUSES[$i]}")
            DISPLAY_INDICES+=("$i")
        fi
    done

    if [ ${#DISPLAY_SKILLS[@]} -eq 0 ]; then
        echo ""
        if [ "$filter" = "disabled" ]; then
            echo -e "${DIM}No disabled skills found.${NC}"
        else
            echo -e "${DIM}No enabled skills found.${NC}"
        fi
        echo ""
        return 1
    fi

    echo ""
    printf "${BOLD}%-4s %-2s %-30s${NC}\n" "#" "" "Skill"
    printf "%-4s %-2s %-30s\n" "---" "--" "------------------------------"

    for i in "${!DISPLAY_SKILLS[@]}"; do
        local indicator
        if [ "${DISPLAY_STATUSES[$i]}" = "enabled" ]; then
            indicator="${GREEN}●${NC}"
        else
            indicator="${RED}○${NC}"
        fi
        printf "%-4s %b %-30s\n" "$((i + 1))" "$indicator" "${DISPLAY_SKILLS[$i]}"
    done

    echo ""
    echo -e "${DIM}● enabled  ○ disabled${NC}"
    echo ""
}

list_skills() {
    display_skills "all"
}

info_skill() {
    local name="$1"
    local skill_dir=""
    local status=""

    if [ -d "$SKILLS_DIR/$name" ]; then
        skill_dir="$SKILLS_DIR/$name"
        status="enabled"
    elif [ -d "$DISABLED_DIR/$name" ]; then
        skill_dir="$DISABLED_DIR/$name"
        status="disabled"
    else
        echo -e "\n  ${YELLOW}Not found:${NC} $name\n"
        return 1
    fi

    local skill_md="$skill_dir/SKILL.md"
    local description=""
    local file_count=0
    local size=""

    file_count=$(find "$skill_dir" -type f | wc -l | tr -d ' ')
    size=$(du -sh "$skill_dir" 2>/dev/null | awk '{print $1}')

    if [ -f "$skill_md" ]; then
        description=$(sed -n '/^description:/s/^description: *//p' "$skill_md" | head -1)
    fi

    echo ""
    echo -e "  ${BOLD}$name${NC}"
    echo -e "  Status:      $([ "$status" = "enabled" ] && echo -e "${GREEN}enabled${NC}" || echo -e "${RED}disabled${NC}")"
    echo -e "  Path:        $skill_dir"
    [ -n "$description" ] && echo -e "  Description: $description"
    echo -e "  Files:       $file_count"
    echo -e "  Size:        $size"

    if [ -f "$skill_md" ]; then
        echo -e "  SKILL.md:    ${GREEN}present${NC}"
    else
        echo -e "  SKILL.md:    ${YELLOW}missing${NC}"
    fi
    echo ""
}

toggle_skill() {
    local name="$1"
    if [ -d "$SKILLS_DIR/$name" ]; then
        mv "$SKILLS_DIR/$name" "$DISABLED_DIR/$name"
        echo -e "  ${RED}Disabled${NC} $name"
    elif [ -d "$DISABLED_DIR/$name" ]; then
        mv "$DISABLED_DIR/$name" "$SKILLS_DIR/$name"
        echo -e "  ${GREEN}Enabled${NC}  $name"
    else
        echo -e "  ${YELLOW}Not found:${NC} $name"
    fi
}

enable_skill() {
    local name="$1"
    if [ -d "$DISABLED_DIR/$name" ]; then
        mv "$DISABLED_DIR/$name" "$SKILLS_DIR/$name"
        echo -e "  ${GREEN}Enabled${NC}  $name"
    elif [ -d "$SKILLS_DIR/$name" ]; then
        echo -e "  ${DIM}Already enabled:${NC} $name"
    else
        echo -e "  ${YELLOW}Not found:${NC} $name"
    fi
}

disable_skill() {
    local name="$1"
    if [ -d "$SKILLS_DIR/$name" ]; then
        mv "$SKILLS_DIR/$name" "$DISABLED_DIR/$name"
        echo -e "  ${RED}Disabled${NC} $name"
    elif [ -d "$DISABLED_DIR/$name" ]; then
        echo -e "  ${DIM}Already disabled:${NC} $name"
    else
        echo -e "  ${YELLOW}Not found:${NC} $name"
    fi
}

interactive_pick() {
    local action="$1"  # toggle, enable, or disable
    local filter="all"

    if [ "$action" = "enable" ]; then
        filter="disabled"
    elif [ "$action" = "disable" ]; then
        filter="enabled"
    fi

    display_skills "$filter" || return

    local total=${#DISPLAY_SKILLS[@]}

    if [ "$action" = "enable" ]; then
        echo -e "${CYAN}Enter numbers to enable (comma separated, or 'all')${NC}"
    elif [ "$action" = "disable" ]; then
        echo -e "${CYAN}Enter numbers to disable (comma separated, or 'all')${NC}"
    else
        echo -e "${CYAN}Enter numbers to toggle (comma separated, or 'all')${NC}"
    fi

    echo -e "${DIM}Press Enter to exit${NC}"
    printf "> "
    read -r input

    [ -z "$input" ] && return

    echo ""
    if [ "$input" = "all" ]; then
        for name in "${DISPLAY_SKILLS[@]}"; do
            if [ "$action" = "enable" ]; then
                enable_skill "$name"
            elif [ "$action" = "disable" ]; then
                disable_skill "$name"
            else
                toggle_skill "$name"
            fi
        done
    else
        IFS=',' read -ra nums <<< "$input"
        for num in "${nums[@]}"; do
            num=$(echo "$num" | tr -d ' ')
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$total" ]; then
                local idx=$((num - 1))
                local name="${DISPLAY_SKILLS[$idx]}"
                if [ "$action" = "enable" ]; then
                    enable_skill "$name"
                elif [ "$action" = "disable" ]; then
                    disable_skill "$name"
                else
                    toggle_skill "$name"
                fi
            else
                echo -e "  ${YELLOW}Invalid:${NC} $num"
            fi
        done
    fi

    echo ""
    echo -e "${DIM}Changes take effect on next Claude Code session${NC}"
}

show_help() {
    echo ""
    echo -e "${BOLD}skill-manager${NC} v${VERSION}"
    echo "  Manage global Claude Code skills"
    echo ""
    echo -e "${BOLD}Usage:${NC}"
    echo "  skill-manager              Interactive mode"
    echo "  skill-manager list         Show all skills with status"
    echo "  skill-manager info <name>  Show details about a skill"
    echo "  skill-manager enable [n]   Enable skill(s), interactive if no name given"
    echo "  skill-manager disable [n]  Disable skill(s), interactive if no name given"
    echo "  skill-manager help         Show this help"
    echo "  skill-manager version      Show version"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  skill-manager list"
    echo "  skill-manager info jira-create"
    echo "  skill-manager disable jira-create jira-get"
    echo "  skill-manager enable jira-create"
    echo ""
}

# Main
case "${1:-}" in
    list)
        list_skills
        ;;
    info)
        shift
        [ $# -eq 0 ] && { echo "Usage: skill-manager info <name>"; exit 1; }
        info_skill "$1"
        ;;
    enable)
        shift
        if [ $# -eq 0 ]; then
            interactive_pick "enable"
        else
            echo ""
            for name in "$@"; do enable_skill "$name"; done
            echo ""
        fi
        ;;
    disable)
        shift
        if [ $# -eq 0 ]; then
            interactive_pick "disable"
        else
            echo ""
            for name in "$@"; do disable_skill "$name"; done
            echo ""
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    version|--version|-v)
        echo "skill-manager v${VERSION}"
        ;;
    *)
        interactive_pick "toggle"
        ;;
esac
