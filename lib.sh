#!/bin/bash

TMPDIR=tmp
REPO=$0
CHANGE_COUNT=0
COMMIT_COUNT=0
CURRENT_BRANCH=master

function checkout { # branch
    git checkout $1
    CURRENT_BRANCH=$1
}

function checkout_b { # branch [onBranch]
    git checkout -b $1 $2
    CURRENT_BRANCH=$1
}

function change { # file
    CHANGE_COUNT=$[ $CHANGE_COUNT + 1 ]
    echo "Change $CHANGE_COUNT from $CURRENT_BRANCH" >> $1
}

function commit { # msg...
    local msg=$(echo $@)
    if [[ -z $msg ]]; then
	msg="$CURRENT_BRANCH: Commit $COMMIT_COUNT"
    else
	msg="$CURRENT_BRANCH: $msg"
    fi
    COMMIT_COUNT=$[ $COMMIT_COUNT + 1 ]
    git add -A . > /dev/null
    git commit -m "$msg" > /dev/null
    echo "COMMIT: $msg"
}

function chain_commit { # ntimes file
    for ((i=0 ; i < $1; ++i)); do
	change $2
	commit
    done
}

function merge { # branch
    git merge --no-ff --no-edit $1
}

function log { # msg...
    local opts=""
    opts="$opts --all"
    opts="$opts --graph"
    opts="$opts --oneline"
    opts="$opts --decorate"
    #opts="$opts --first-parent"

    echo
    echo "LOG: $@"
    #echo "OPTS: $opts"
    echo
    git log $opts
    echo
    if [[ -z $OPT_DELAY ]]; then
	echo "Press ENTER to continue"
	echo
	read
    else
	echo
	sleep $OPT_DELAY
    fi
    clear
}

function init {
    rm -rf $TMPDIR/$REPO
    mkdir -p $TMPDIR
    pushd $TMPDIR
    git init $REPO
    cd $REPO
    clear
}
