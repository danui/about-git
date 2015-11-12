#!/bin/bash

source lib.sh

function main {
    init

    change README
    commit
    log "Initial commit"

    checkout_b develop master
    chain_commit 2 Component-1
    log "Modified Component-1"

    checkout_b rc/5.1.0 master
    merge develop
    tag rc5.1.0_r1
    log "Tagged rc5.1.0_r1"

    checkout develop
    chain_commit 2 Component-2
    log "Modified Component-2 on the develop branch"

    checkout_b hotfix-1 rc/5.1.0
    change Component-1
    commit "Fix Component-1"
    log "Fixed Component-1 on a hotfix-1 branch"

    checkout rc/5.1.0
    merge hotfix-1
    tag rc5.1.0_r2
    log "Merge hotfix-1 into rc/5.1.0"

    checkout develop
    merge hotfix-1
    log "Merge hotfix-1 into develop"

    checkout develop
    chain_commit 2 Component-1
    chain_commit 3 Component-2
    log "Development on Components 1 and 2"

    checkout rc/5.1.0
    merge develop
    tag rc5.1.0_r3
    log "Merge in changes from develop into rc/5.1.0"

    checkout develop
    merge rc/5.1.0
    log "Merge rc/5.1.0 into develop"

    checkout master
    merge rc/5.1.0
    tag v5.1.0
    log "Merge rc/5.1.0 into master and tag v5.1.0"
}

main
