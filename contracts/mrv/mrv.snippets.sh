#!/bin/bash

# ============================================================================
# MRV Snippets
# ============================================================================
# This script contains helper functions to deploy and upgrade the MRV contracts.
# Since MRV is a workspace with multiple contracts (carbon-credit, registry, 
# aggregator, etc.), these functions accept the contract name as the first 
# parameter.
#
# Usage:
# source mrv.snippets.sh
# deploy_mrv_contract carbon-credit <init_args>
# ============================================================================

WALLET_PEM="./alice.pem"
PROXY="http://localhost:8085"
CHAIN_ID="chain" # 'D' for Devnet, 'T' for Testnet, '1' for Mainnet, 'chain' for simulator

# Deploy a specific MRV contract
# Example: deploy_mrv_contract carbon-credit 0x<arg1> 0x<arg2>
deploy_mrv_contract() {
    local contract_name=$1
    shift # remaining arguments are passed to the contract init function

    local wasm_path="./${contract_name}/output/mrv-${contract_name}.wasm"

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

# Upgrade a specific MRV contract
# Example: upgrade_mrv_contract carbon-credit erd1... 0x<arg1>
upgrade_mrv_contract() {
    local contract_name=$1
    local contract_address=$2
    shift 2

    local wasm_path="./${contract_name}/output/mrv-${contract_name}.wasm"

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
