#!/bin/bash

source lib.sh

function main {
    init

    change README
    commit
    log "Initial commit"

    checkout_b ticket-1 master
    chain_commit 2 MODULE-1
    log "Modified MODULE-1"

    checkout_b ticket-2 master
    chain_commit 2 MODULE-2
    log "Modified MODULE-2"

    checkout_b ticket-3 master
    chain_commit 3 MODULE-3
    log "Modified MODULE-3"

    checkout_b release-v0.1.0 master
    log "Prepare for release v0.1.0"

    merge ticket-1
    git br revert-this
    log "Merge in ticket-1"

    merge ticket-3
    log "Merge in ticket-3"

    git revert --no-edit -m 1 revert-this
    log "Reverted 'revert-this'"

    echo "v0.1.0" > VERSION
    commit "Update version to v0.1.0"
    log "Update version to v0.1.0"

    checkout master
    git merge --ff-only release-v0.1.0
    log "Advance master to v0.1.0"

    git tag v0.1.0
    log "Tag v0.1.0"

    git branch -d ticket-3 release-v0.1.0 revert-this
    log "Remove ephemeral branches"

    checkout ticket-2
    merge master
    log "Merge master into ticket-2"

    checkout ticket-2
    chain_commit 3 MODULE-2
    log "Edit MODULE-2"

    checkout ticket-1
    merge master
    chain_commit 2 MODULE-1
    log "Edit MODULE-1"

    checkout_b release-v0.2.0 master
    log "Prepare for release v0.2.0"

    merge ticket-1
    log "Merge in ticket-1"

    merge ticket-2
    log "Merge in ticket-2"

    echo "v0.2.0" > VERSION
    commit "Update version to v0.2.0"
    log "Update version to v0.2.0"

    checkout master
    git merge --ff-only release-v0.2.0
    log "Advance master to v0.2.0"

    git tag v0.2.0
    log "Tag v0.2.0"

    git branch -d ticket-1 ticket-2 release-v0.2.0
    log "Remove ephemeral branches"

    echo "Changes on ticket-1 before v0.1.0 are lost!"
    cat MODULE-1
}

main
