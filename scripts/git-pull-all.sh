#!/usr/bin/env bash

# some change

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "error: not a git repository" >&2
    exit 1
fi

if [[ "$(git rev-parse --abbrev-ref HEAD)" == "HEAD" ]]; then
    echo "error: detached HEAD" >&2
    exit 1
fi

gitdir="$(git rev-parse --git-dir)"
case_states=(
    MERGE_HEAD:merge
    CHERRY_PICK_HEAD:cherry-pick
    REVERT_HEAD:revert
    REBASE_HEAD:rebase
    BISECT_LOG:bisect
)
for state in "${case_states[@]}"; do
    file="${state%%:*}"
    name="${state##*:}"
    if [[ -e "$gitdir/$file" ]]; then
        echo "error: $name in progress" >&2
        exit 1
    fi
done

if [[ -d "$gitdir/rebase-merge" || -d "$gitdir/rebase-apply" ]]; then
    echo "error: rebase in progress" >&2
    exit 1
fi

original_branch="$(git rev-parse --abbrev-ref HEAD)"

if [[ -n "$(git status --porcelain)" ]]; then
    echo "error: working tree dirty; commit or stash first" >&2
    exit 1
fi

branches="$(git for-each-ref --format='%(refname:short)' refs/heads)"
total="$(git for-each-ref --format='%(refname:short)' refs/heads | wc -l | tr -d '[:space:]')"

i=0
while IFS= read -r branch; do
    [[ -z "$branch" ]] && continue
    i=$((i + 1))
    echo "($i/$total) Pulling '$branch'"

    git switch "$branch" >/dev/null 2>&1 || {
        echo "error: switch to '$branch' failed" >&2
        exit 1
    }

    if ! git pull --ff-only origin "$branch" >/dev/null 2>&1; then
        echo "error: pull '$branch' failed; manual intervention required" >&2
        echo "note: on '$branch'; was '$original_branch'" >&2
        exit 1
    fi
done <<< "$branches"

git switch "$original_branch" >/dev/null 2>&1 || {
    echo "error: switch back to '$original_branch' failed" >&2
    exit 1
}
