#!/bin/bash
if [ ! -z "$ghprbActualCommit" ]; then
    changed=$(for i in $(git diff-tree --no-commit-id --name-only -r $ghprbActualCommit); do
        dirname $i;
    done | sort | uniq | grep "src" | sed -e 's,^src/,,g')
    for i in $changed; do
        make -C src/$changed clean
        make -C src/$changed
    done
else
    echo "Not a pull request build"
fi;
