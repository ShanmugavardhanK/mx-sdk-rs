#!/usr/bin/env bash
# Usage: ./set_policy_registry.sh <proposal‑id>
# The proposal must be created and signed by the multisig signers.
# ------------------------------------------------------------
# Example (run after the above script finishes):
#   PROPOSAL_ID=$(sc-meta propose \
#       --contract "${GOV_ADDR}" \
#       --function setPolicyRegistryAddress \
#       --args "policy_registry_address:${POLICY_ADDR}" \
#       --sender "${WALLET}")
#   # each signer signs...
#   sc-meta sign --proposal-id "${PROPOSAL_ID}" --signer <SIGNER>
#   sc-meta perform --proposal-id "${PROPOSAL_ID}" --sender "${WALLET}"
