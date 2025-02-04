#!/bin/bash

if [ -z "$SLIDES_OUTPUT_FOLDER" ];
then
    SLIDES_OUTPUT_FOLDER=./dist
    mkdir -p $SLIDES_OUTPUT_FOLDER
fi

function build {
    slides=$1
    echo "Building slides $slides"
    ln -s ../assets/global-bottom.vue "lectures/$slides/global-bottom.vue"
    npm run build -- "lectures/$slides/slides.md" --base /slides/$slides --out "../../$SLIDES_OUTPUT_FOLDER/$slides"
    fail=$?
    rm "lectures/$slides/global-bottom.vue"
}

if [ "$1" != "" ];
then
    build $1
else
    for slides in $(basename -a $(find lectures/* -maxdepth 0 -type d)); do
        if [ $slides != "assets" ]; then
            build $slides
            fail=$?
            if [ $fail != 0 ]; then
                echo "Failed to build slides $slides"
                exit $fail
            fi
        fi
    done
fi
