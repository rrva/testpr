#!/bin/bash
commit="$ghprbActualCommit"

# find Makefile for a directory.
# search backwards upto the workdir root
findNearestMakefileDir() {
    local x
    local start
    x="$1"
    start=$(pwd)
    while [ "$x" != "$start" ] && [ "$x" != "." ] && [ "$x" != "/" ]; do
        if [[ -e "$x/Makefile" ]]; then
            printf "%s\n" "$x"
            break
        fi
        x=$(dirname "$x")
    done
}

if [ ! -z "$commit" ]; then
    # collect all directories where a change has been made
    changed=( \
        $(git diff-tree --no-commit-id --name-only -r "$commit" \
          | egrep "^src" | tr '\n' '\0' | xargs -I {} -0 dirname {} \
          | sort | uniq \
         ) \
    )
    # find the nearest makefile for each directory
    makefiles=( \
        $(for x in "${changed[@]}"; do
            findNearestMakefileDir "$x"
        done | sort | uniq)
    )
    # run make for all changed directories
    for m in "${makefiles[@]}"; do
        make -C "$m" clean
        make -C "$m"
    done
else
    echo "Not a pull request build"
fi
