#!/bin/bash

# ============================================================================
# DRWA Snippets
# ============================================================================
# This script contains helper functions to deploy and upgrade the DRWA contracts.
# Since DRWA is a workspace with multiple contracts (asset-manager, attestation, 
# identity-registry, policy-registry, drwa-auth-admin), these functions accept 
# the contract name as the first parameter.
#
# Usage:
# source drwa.snippets.sh
# deploy_drwa_contract asset-manager <governance_address_hex>
# ============================================================================

WALLET_PEM="alice.pem"
PROXY="http://localhost:8085"
CHAIN_ID="chain"

# Helper to build all contracts in the DRWA workspace
build_all() {
    echo "Building all DRWA contracts..."
    for dir in asset-manager attestation identity-registry policy-registry drwa-auth-admin; do
        if [ -d "$dir" ]; then
            echo "Building $dir..."
            (cd "$dir" && sc-meta all build)
        fi
    done
}

# Deploy a specific DRWA contract
# Example: deploy_drwa_contract asset-manager 0x<governance_address_hex>
deploy_drwa_contract() {
    local contract_name=$1
    shift # remaining arguments are passed to the contract init function

    local wasm_path="./${contract_name}/output/drwa-${contract_name}.wasm"

    if [ ! -f "${wasm_path}" ]; then
        echo "WASM file not found at ${wasm_path}. Please build the contract first."
        return
    fi

    sc-meta tx deploy \
        --bytecode="${wasm_path}" \
        --pem="${WALLET_PEM}" \
        --proxy="${PROXY}" \
        --chain="${CHAIN_ID}" \
        --arguments "$@" \
        --gas-limit=150000000 \
        --send || return
}

# Upgrade a specific DRWA contract
# Example: upgrade_drwa_contract asset-manager erd1... 0x<governance_address_hex>
upgrade_drwa_contract() {
    local contract_name=$1
    local contract_address=$2
    shift 2

    local wasm_path="./${contract_name}/output/drwa-${contract_name}.wasm"

    if [ ! -f "${wasm_path}" ]; then
        echo "WASM file not found at ${wasm_path}. Please build the contract first."
        return
    fi

    sc-meta tx upgrade "${contract_address}" \
        --bytecode="${wasm_path}" \
        --pem="${WALLET_PEM}" \
        --proxy="${PROXY}" \
        --chain="${CHAIN_ID}" \
        --arguments "$@" \
        --gas-limit=150000000 \
        --send || return
}
