
CMN="--disable_auto_cache_key_gen"


echo "******** Running: AToken.conf   ****************"
certoraRun $CMN certora/conf/AToken.conf

echo "******** Running: AToken-problematic-rules.conf   ****************"
certoraRun $CMN certora/conf/AToken-problematic-rules.conf \
           --rule totalSupplyEqualsSumAllBalance additiveBurn additiveTransfer

echo "******** Running: token-v3-general.conf   ****************"
certoraRun $CMN certora/conf/token-v3-general.conf

echo "******** Running: token-v3-erc20.conf   ****************"
certoraRun $CMN certora/conf/token-v3-erc20.conf

echo "******** Running: token-v3-delegate.conf   ****************"
certoraRun $CMN certora/conf/token-v3-delegate.conf

echo "******** Running: token-v3-delegate-HL-rules.conf:::vp_change_in_balance_affect_power_DELEGATEE   ****************"
certoraRun $CMN certora/conf/token-v3-delegate-HL-rules.conf \
           --rule vp_change_in_balance_affect_power_DELEGATEE \
           --msg "delegate-HL-rules vp_change_in_balance_affect_power_DELEGATEE"

echo "******** Running: token-v3-delegate-HL-rules.conf:::vp_change_of_balance_affect_power_NON_DELEGATEE   ****************"
certoraRun $CMN certora/conf/token-v3-delegate-HL-rules.conf \
           --rule vp_change_of_balance_affect_power_NON_DELEGATEE \
           --msg "delegate-HL-rules vp_change_of_balance_affect_power_NON_DELEGATEE"

echo "******** Running: token-v3-delegate-HL-rules.conf:::pp_change_in_balance_affect_power_DELEGATEE   ****************"
certoraRun $CMN certora/conf/token-v3-delegate-HL-rules.conf \
           --rule pp_change_in_balance_affect_power_DELEGATEE \
           --msg "delegate-HL-rules pp_change_in_balance_affect_power_DELEGATEE"

echo "******** Running: token-v3-delegate-HL-rules.conf:::pp_change_of_balance_affect_power_NON_DELEGATEE   ****************"
certoraRun $CMN certora/conf/token-v3-delegate-HL-rules.conf \
           --rule pp_change_of_balance_affect_power_NON_DELEGATEE \
           --msg "delegate-HL-rules pp_change_of_balance_affect_power_NON_DELEGATEE"

echo "******** Running: token-v3-delegate-HL-rules.conf:::other   ****************"
certoraRun $CMN certora/conf/token-v3-delegate-HL-rules.conf \
           --rule mirror_votingDelegatee_correct mirror_propositionDelegatee_correct mirror_delegationMode_correct mirror_balance_correct inv_voting_power_correct inv_proposition_power_correct user_cant_voting_delegate_to_himself user_cant_proposition_delegate_to_himself no_function_changes_both_balance_and_delegation_state \
           --msg "delegate-HL-rules other rules"

echo "******** Running: token-v3-community.conf   ****************"
certoraRun $CMN certora/conf/token-v3-community.conf



