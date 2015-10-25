#!/bin/bash
commit="$ghprbActualCommit"

containsElement () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

findNearestMakefileDir() {
    local x
    local start
    x="$1"
    start=$(pwd)
    while [ "$x" != "$start" ] && [ "$x" != "." ] && [ "$x" != "/" ]; do
        if [[ -e "$x/Makefile" ]]; then
            printf "%s\0" "$x"
            break
        fi
        x=$(dirname "$x");
    done
}

if [ ! -z "$commit" ]; then
    changed=( \
        $(git diff-tree --no-commit-id --name-only -r "$commit" \
        | egrep "^src" | tr '\n' '\0' | xargs -0 dirname | sort | uniq ) \
    )
    makefiles=( \
        $(for x in "${changed[@]}"; do
            findNearestMakefileDir "$x"
        done | sort | uniq)
    )
    for m in "${makefiles[@]}"; do
        make -C "$m" clean
        make -C "$m" 
    done
else
    echo "Not a pull request build"
fi
