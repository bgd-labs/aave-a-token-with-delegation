
/*==============================================================================================
  This is a specification file for the verification of delegation features.
  This file was adapted from AaveTokenV3.sol smart contract to ATOKEN-WITH-DELEGATION smart contract.
  This file is run by the command line: 
                certoraRun --send_only certora/conf/token-v3-delegate.conf
  It uses the harness file: certora/harness/ATokenWithDelegation_Harness.sol
  
  IMPORTANT:
  ---------
  The rules are verified under the following strong assumption:
              _SymbolicLendingPoolL1.getReserveNormalizedIncome() == RAY().
  That means that the liquidity index is 1.
  =============================================================================================*/

import "base_token_v3.spec";

using DummyERC20_aTokenUnderlying as Underlying;
using SymbolicLendingPoolL1 as _SymbolicLendingPoolL1;

definition RAY() returns uint256 = 10^27;

methods {
    function _SymbolicLendingPoolL1.getReserveNormalizedIncome(address) external returns (uint256)  => index();
    function _.rayMul(uint256 a,uint256 b) internal => rayMul_MI(a,b) expect uint256 ALL;
    function _.rayDiv(uint256 a,uint256 b) internal => rayDiv_MI(a,b) expect uint256 ALL;
}

ghost index() returns uint256 {
    axiom index()==RAY();
}

ghost rayMul_MI(mathint , mathint) returns uint256 {
    axiom forall mathint x. forall mathint y. to_mathint(rayMul_MI(x,y)) == x ;
}
ghost rayDiv_MI(mathint , mathint) returns uint256 {
    axiom forall mathint x. forall mathint y. to_mathint(rayDiv_MI(x,y)) == x ;
}









persistent ghost mapping(address => mathint) sum_all_voting_delegated_power {
    init_state axiom forall address delegatee. sum_all_voting_delegated_power[delegatee] == 0;
}
persistent ghost mapping(address => mathint) sum_all_proposition_delegated_power {
    init_state axiom forall address delegatee. sum_all_proposition_delegated_power[delegatee] == 0;
}

// =========================================================================
//   mirror_votingDelegatee
// =========================================================================
persistent ghost mapping(address => address) mirror_votingDelegatee { 
    init_state axiom forall address a. mirror_votingDelegatee[a] == 0;
}
hook Sstore _votingDelegatee[KEY address delegator] address new_delegatee (address old_delegatee) STORAGE {
    mirror_votingDelegatee[delegator] = new_delegatee;
    if ((mirror_delegationMode[delegator]==FULL_POWER_DELEGATED() ||
         mirror_delegationMode[delegator]==VOTING_DELEGATED()) &&
        new_delegatee != old_delegatee) { // if a delegator changes his delegatee
        sum_all_voting_delegated_power[new_delegatee] =
            sum_all_voting_delegated_power[new_delegatee] + (mirror_balance[delegator]/(10^10)*(10^10));
        sum_all_voting_delegated_power[old_delegatee] = 
            sum_all_voting_delegated_power[old_delegatee] - (mirror_balance[delegator]/(10^10)*(10^10));
    }
}
hook Sload address val _votingDelegatee[KEY address delegator] STORAGE {
    require(mirror_votingDelegatee[delegator] == val);
}
invariant mirror_votingDelegatee_correct(address a)
    mirror_votingDelegatee[a] == getVotingDelegatee(a);


// =========================================================================
//   mirror_propositionDelegatee
// =========================================================================
persistent ghost mapping(address => address) mirror_propositionDelegatee { 
    init_state axiom forall address a. mirror_propositionDelegatee[a] == 0;
}
hook Sstore _propositionDelegatee[KEY address delegator] address new_delegatee (address old_delegatee) STORAGE {
    mirror_propositionDelegatee[delegator] = new_delegatee;
    if ((mirror_delegationMode[delegator]==FULL_POWER_DELEGATED() ||
         mirror_delegationMode[delegator]==PROPOSITION_DELEGATED()) &&
        new_delegatee != old_delegatee) { // if a delegator changes his delegatee
        sum_all_proposition_delegated_power[new_delegatee] =
            sum_all_proposition_delegated_power[new_delegatee] + (mirror_balance[delegator]/(10^10)*(10^10));
        sum_all_proposition_delegated_power[old_delegatee] = 
            sum_all_proposition_delegated_power[old_delegatee] - (mirror_balance[delegator]/(10^10)*(10^10));
    }
}
hook Sload address val _propositionDelegatee[KEY address delegator] STORAGE {
    require(mirror_propositionDelegatee[delegator] == val);
}
invariant mirror_propositionDelegatee_correct(address a)
    mirror_propositionDelegatee[a] == getPropositionDelegatee(a);


// =========================================================================
//   mirror_delegationMode
// =========================================================================
persistent ghost mapping(address => ATokenWithDelegation_Harness.DelegationMode) mirror_delegationMode { 
    init_state axiom forall address a. mirror_delegationMode[a] ==
        ATokenWithDelegation_Harness.DelegationMode.NO_DELEGATION;
}
hook Sstore _userState[KEY address a].delegationMode ATokenWithDelegation_Harness.DelegationMode newVal (ATokenWithDelegation_Harness.DelegationMode oldVal) STORAGE {
    mirror_delegationMode[a] = newVal;

    if ( (newVal==VOTING_DELEGATED() || newVal==FULL_POWER_DELEGATED())
         &&
         (oldVal!=VOTING_DELEGATED() && oldVal!=FULL_POWER_DELEGATED())
       ) { // if we start to delegate VOTING now
        sum_all_voting_delegated_power[mirror_votingDelegatee[a]] =
            sum_all_voting_delegated_power[mirror_votingDelegatee[a]] +
            (mirror_balance[a]/(10^10)*(10^10));
    }

    if ( (newVal==PROPOSITION_DELEGATED() || newVal==FULL_POWER_DELEGATED())
         &&
         (oldVal!=PROPOSITION_DELEGATED() && oldVal!=FULL_POWER_DELEGATED())
       ) { // if we start to delegate PROPOSITION now
        sum_all_proposition_delegated_power[mirror_propositionDelegatee[a]] =
            sum_all_proposition_delegated_power[mirror_propositionDelegatee[a]] +
            (mirror_balance[a]/(10^10)*(10^10));
    }
}
hook Sload ATokenWithDelegation_Harness.DelegationMode val _userState[KEY address a].delegationMode STORAGE {
    require(mirror_delegationMode[a] == val);
}
invariant mirror_delegationMode_correct(address a)
    mirror_delegationMode[a] == getDelegationMode(a);



// =========================================================================
//   mirror_balance
// =========================================================================
persistent ghost mapping(address => uint120) mirror_balance { 
    init_state axiom forall address a. mirror_balance[a] == 0;
}
hook Sstore _userState[KEY address a].balance uint120 balance (uint120 old_balance) STORAGE {
    mirror_balance[a] = balance;
    //sum_all_voting_delegated_power[a] = sum_all_voting_delegated_power[a] + balance - old_balance;
    // The code should be:
    // if a delegates to b, sum_all_voting_delegated_power[b] += the diff of balances of a
    if (a!=0 &&
        (mirror_delegationMode[a]==FULL_POWER_DELEGATED() ||
         mirror_delegationMode[a]==VOTING_DELEGATED() )
        )
        sum_all_voting_delegated_power[mirror_votingDelegatee[a]] =
            sum_all_voting_delegated_power[mirror_votingDelegatee[a]] +
            (balance/ (10^10) * (10^10)) - (old_balance/ (10^10) * (10^10)) ;

    if (a!=0 &&
        (mirror_delegationMode[a]==FULL_POWER_DELEGATED() ||
         mirror_delegationMode[a]==PROPOSITION_DELEGATED() )
        )
        sum_all_proposition_delegated_power[mirror_propositionDelegatee[a]] =
            sum_all_proposition_delegated_power[mirror_propositionDelegatee[a]] +
            (balance/ (10^10) * (10^10)) - (old_balance/ (10^10) * (10^10)) ;
}
hook Sload uint120 bal _userState[KEY address a].balance STORAGE {
    require(mirror_balance[a] == bal);
}
invariant mirror_balance_correct(address a)
    mirror_balance[a] == getBalance(a);



definition is_mint_burn_func(method f) returns bool =
    f.selector == sig:burn(address,address,uint256,uint256).selector ||
    f.selector == sig:mintToTreasury(uint256,uint256).selector ||
    f.selector == sig:mint(address,address,uint256,uint256).selector;


/* The following invariant says that the voting power of a user is as it should be.
   That is, the sum of all balances of users that delegate to him, plus his balance in case 
   that he is not delegating  */

invariant inv_voting_power_correct(address user) 
    user != 0 =>
    (
     to_mathint(getPowerCurrent(user, VOTING_POWER()))
     ==
     sum_all_voting_delegated_power[user] +
     ( (mirror_delegationMode[user]==FULL_POWER_DELEGATED() ||
        mirror_delegationMode[user]==VOTING_DELEGATED())     ? 0 : mirror_balance[user])
    )
    filtered { f -> !f.isView && f.contract == currentContract}
{
    preserved with (env e) {
        requireInvariant user_cant_voting_delegate_to_himself();
    }
}

invariant inv_proposition_power_correct(address user)
    user != 0 =>
    (
     to_mathint(getPowerCurrent(user, PROPOSITION_POWER()))
     ==
     sum_all_proposition_delegated_power[user] +
     ( (mirror_delegationMode[user]==FULL_POWER_DELEGATED() ||
        mirror_delegationMode[user]==PROPOSITION_DELEGATED())     ? 0 : mirror_balance[user])
    )
    filtered { f -> !f.isView && f.contract == currentContract}
{
    preserved with (env e) {
        requireInvariant user_cant_proposition_delegate_to_himself();
    }
}





rule no_function_changes_both_balance_and_delegation_state(method f, address bob) {
    env e;
    calldataarg args;

    require (bob != 0);

    uint256 bob_balance_before = balanceOf(bob);
    bool is_bob_delegating_voting_before = isDelegatingVoting(bob);
    address bob_delegatee_before = mirror_votingDelegatee[bob];

    f(e,args);

    uint256 bob_balance_after = balanceOf(bob);
    bool is_bob_delegating_voting_after = isDelegatingVoting(bob);
    address bob_delegatee_after = mirror_votingDelegatee[bob];

    assert (bob_balance_before != bob_balance_after =>
            (is_bob_delegating_voting_before==is_bob_delegating_voting_after &&
             bob_delegatee_before == bob_delegatee_after)
           );

    assert (bob_delegatee_before != bob_delegatee_after =>
            bob_balance_before == bob_balance_after
           );

    assert (is_bob_delegating_voting_before!=is_bob_delegating_voting_after =>
            bob_balance_before == bob_balance_after            
            );
  
}



invariant user_cant_voting_delegate_to_himself()
    forall address a. a!=0 => mirror_votingDelegatee[a] != a;

invariant user_cant_proposition_delegate_to_himself()
    forall address a. a!=0 => mirror_propositionDelegatee[a] != a;



//===================================================================================
//===================================================================================
// High-level rules that verify that a change in the balance (generated by any function)
// results in a correct change in the power.
//===================================================================================
//===================================================================================

/*
    @Rule

    @Description:
        Verify correct voting power after any change in (any user) balance.
        We consider the following case:
        - bob is the delegatee of alice1, and possibly of alice2. No other user delegates
        to bob.
        - bob may be delegating and may not.
        - We assume that the function that was call doesn't change the delegation state of neither
          bob, alice1 or alice2.

        We emphasize that we assume that no function alters both the balance of a user (Bob),
        and its delegation state (including the delegatee). We indeed check this property in the
        rule no_function_changes_both_balance_and_delegation_state().
        
    @Note:

    @Link:
*/
rule vp_change_in_balance_affect_power_DELEGATEE(method f,address bob,address alice1,address alice2)
//    filtered {f -> !is_mint_burn_func(f)}
{
    env e;
    calldataarg args;
    require bob != 0; require alice1 != 0; require alice2 != 0;
    require (bob != alice1 && bob != alice2 && alice1 != alice2);

    uint256 bob_bal_before = balanceOf(bob);
    mathint bob_power_before = getPowerCurrent(bob, VOTING_POWER());
    bool is_bob_delegating_before = isDelegatingVoting(bob);

    uint256 alice1_bal_before = balanceOf(alice1);
    bool is_alice1_delegating_before = isDelegatingVoting(alice1);
    address alice1D_before = getVotingDelegatee(alice1); // alice1D == alice1_delegatee
    uint256 alice2_bal_before = balanceOf(alice2);
    bool is_alice2_delegating_before = isDelegatingVoting(alice2);
    address alice2D_before = getVotingDelegatee(alice2); // alice2D == alice2_delegatee

    // The following says that alice1 is delegating to bob, alice2 may do so, and no other
    // user may do so.
    require (is_alice1_delegating_before && alice1D_before == bob);
    require forall address a. (a!=alice1 && a!=alice2) =>
        (mirror_votingDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=VOTING_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );

    requireInvariant user_cant_voting_delegate_to_himself();
    requireInvariant inv_voting_power_correct(alice1);
    requireInvariant inv_voting_power_correct(alice2);
    requireInvariant inv_voting_power_correct(bob);

    f(e,args);
    
    uint256 alice1_bal_after = balanceOf(alice1);
    mathint alice1_power_after = getPowerCurrent(alice1,VOTING_POWER());
    bool is_alice1_delegating_after = isDelegatingVoting(alice1);
    address alice1D_after = getVotingDelegatee(alice1); // alice1D == alice1_delegatee
    uint256 alice2_bal_after = balanceOf(alice2);
    mathint alice2_power_after = getPowerCurrent(alice2,VOTING_POWER());
    bool is_alice2_delegating_after = isDelegatingVoting(alice2);
    address alice2D_after = getVotingDelegatee(alice2); // alice2D == alice2_delegatee

    require (is_alice1_delegating_after && alice1D_after == bob);
    require forall address a. (a!=alice1 && a!=alice2) =>
        (mirror_votingDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=VOTING_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );
    // No change in the delegation state of alice2
    require (is_alice2_delegating_before==is_alice2_delegating_after &&
             alice2D_before == alice2D_after);

    uint256 bob_bal_after = balanceOf(bob);
    mathint bob_power_after = getPowerCurrent(bob, VOTING_POWER());
    bool is_bob_delegating_after = isDelegatingVoting(bob);

    // No change in the delegation state of bob
    require (is_bob_delegating_before == is_bob_delegating_after);

    mathint alice1_diff = 
        (is_alice1_delegating_after && alice1D_after==bob) ?
        normalize(alice1_bal_after) - normalize(alice1_bal_before) : 0;

    mathint alice2_diff = 
        (is_alice2_delegating_after && alice2D_after==bob) ?
        normalize(alice2_bal_after) - normalize(alice2_bal_before) : 0;

    mathint bob_diff = bob_bal_after - bob_bal_before;
    
    assert
        !is_bob_delegating_after =>
        bob_power_after == bob_power_before + alice1_diff + alice2_diff + bob_diff;

    assert
        is_bob_delegating_after =>
        bob_power_after == bob_power_before + alice1_diff + alice2_diff;
}



/*
    @Rule

    @Description:
        Verify correct voting power after any change in (any user) balance.
        We consider the following case:
        - No user is delegating to bob.
        - bob may be delegating and may not.
        - We assume that the function that was call doesn't change the delegation state of bob.

        We emphasize that we assume that no function alters both the balance of a user (Bob),
        and its delegation state (including the delegatee). We indeed check this property in the
        rule no_function_changes_both_balance_and_delegation_state().
        
    @Note:

    @Link:
*/
rule vp_change_of_balance_affect_power_NON_DELEGATEE(method f, address bob) {
    env e;
    calldataarg args;
    require bob != 0;
    
    uint256 bob_bal_before = balanceOf(bob);
    mathint bob_power_before = getPowerCurrent(bob, VOTING_POWER());
    bool is_bob_delegating_before = isDelegatingVoting(bob);

    // The following says the no one delegates to bob
    require forall address a. 
        (mirror_votingDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=VOTING_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );

    requireInvariant user_cant_voting_delegate_to_himself();
    requireInvariant inv_voting_power_correct(bob);

    f(e,args);
    
    require forall address a. 
        (mirror_votingDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=VOTING_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );

    uint256 bob_bal_after = balanceOf(bob);
    mathint bob_power_after = getPowerCurrent(bob, VOTING_POWER());
    bool is_bob_delegating_after = isDelegatingVoting(bob);
    mathint bob_diff = bob_bal_after - bob_bal_before;

    require (is_bob_delegating_before == is_bob_delegating_after);
    
    assert !is_bob_delegating_after => bob_power_after==bob_power_before + bob_diff;
    assert is_bob_delegating_after => bob_power_after==bob_power_before;
}




/*
    @Rule

    @Description:
        Verify correct proposition power after any change in (any user) balance.
        We consider the following case:
        - bob is the delegatee of alice1, and possibly of alice2. No other user delegates
        to bob.
        - bob may be delegating and may not.
        - We assume that the function that was call doesn't change the delegation state of neither
          bob, alice1 or alice2.

        We emphasize that we assume that no function alters both the balance of a user (Bob),
        and its delegation state (including the delegatee). We indeed check this property in the
        rule no_function_changes_both_balance_and_delegation_state().
        
    @Note:

    @Link:
*/
rule pp_change_in_balance_affect_power_DELEGATEE(method f,address bob,address alice1,address alice2)
//    filtered {f -> !is_mint_burn_func(f)}

{
    env e;
    calldataarg args;
    require bob != 0; require alice1 != 0; require alice2 != 0;
    require (bob != alice1 && bob != alice2 && alice1 != alice2);

    uint256 bob_bal_before = balanceOf(bob);
    mathint bob_power_before = getPowerCurrent(bob, PROPOSITION_POWER());
    bool is_bob_delegating_before = isDelegatingProposition(bob);

    uint256 alice1_bal_before = balanceOf(alice1);
    bool is_alice1_delegating_before = isDelegatingProposition(alice1);
    address alice1D_before = getPropositionDelegatee(alice1); // alice1D == alice1_delegatee
    uint256 alice2_bal_before = balanceOf(alice2);
    bool is_alice2_delegating_before = isDelegatingProposition(alice2);
    address alice2D_before = getPropositionDelegatee(alice2); // alice2D == alice2_delegatee

    // The following says that alice1 is delegating to bob, alice2 may do so, and no other
    // user may do so.
    require (is_alice1_delegating_before && alice1D_before == bob);
    require forall address a. (a!=alice1 && a!=alice2) =>
        (mirror_propositionDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=PROPOSITION_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );

    requireInvariant user_cant_proposition_delegate_to_himself();
    requireInvariant inv_proposition_power_correct(alice1);
    requireInvariant inv_proposition_power_correct(alice2);
    requireInvariant inv_proposition_power_correct(bob);

    f(e,args);
    
    uint256 alice1_bal_after = balanceOf(alice1);
    mathint alice1_power_after = getPowerCurrent(alice1,PROPOSITION_POWER());
    bool is_alice1_delegating_after = isDelegatingProposition(alice1);
    address alice1D_after = getPropositionDelegatee(alice1); // alice1D == alice1_delegatee
    uint256 alice2_bal_after = balanceOf(alice2);
    mathint alice2_power_after = getPowerCurrent(alice2,PROPOSITION_POWER());
    bool is_alice2_delegating_after = isDelegatingProposition(alice2);
    address alice2D_after = getPropositionDelegatee(alice2); // alice2D == alice2_delegatee

    require (is_alice1_delegating_after && alice1D_after == bob);
    require forall address a. (a!=alice1 && a!=alice2) =>
        (mirror_propositionDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=PROPOSITION_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );
    // No change in the delegation state of alice2
    require (is_alice2_delegating_before==is_alice2_delegating_after &&
             alice2D_before == alice2D_after);

    uint256 bob_bal_after = balanceOf(bob);
    mathint bob_power_after = getPowerCurrent(bob, PROPOSITION_POWER());
    bool is_bob_delegating_after = isDelegatingProposition(bob);

    // No change in the delegation state of bob
    require (is_bob_delegating_before == is_bob_delegating_after);

    mathint alice1_diff = 
        (is_alice1_delegating_after && alice1D_after==bob) ?
        normalize(alice1_bal_after) - normalize(alice1_bal_before) : 0;

    mathint alice2_diff = 
        (is_alice2_delegating_after && alice2D_after==bob) ?
        normalize(alice2_bal_after) - normalize(alice2_bal_before) : 0;

    mathint bob_diff = bob_bal_after - bob_bal_before;
    
    assert
        !is_bob_delegating_after =>
        bob_power_after == bob_power_before + alice1_diff + alice2_diff + bob_diff;

    assert
        is_bob_delegating_after =>
        bob_power_after == bob_power_before + alice1_diff + alice2_diff;
}



/*
    @Rule

    @Description:
        Verify correct proposition power after any change in (any user) balance.
        We consider the following case:
        - No user is delegating to bob.
        - bob may be delegating and may not.
        - We assume that the function that was call doesn't change the delegation state of bob.

        We emphasize that we assume that no function alters both the balance of a user (Bob),
        and its delegation state (including the delegatee). We indeed check this property in the
        rule no_function_changes_both_balance_and_delegation_state().
        
    @Note:

    @Link:
*/

rule pp_change_of_balance_affect_power_NON_DELEGATEE(method f, address bob) {
    env e;
    calldataarg args;
    require bob != 0;
    
    uint256 bob_bal_before = balanceOf(bob);
    mathint bob_power_before = getPowerCurrent(bob, PROPOSITION_POWER());
    bool is_bob_delegating_before = isDelegatingProposition(bob);

    // The following says the no one delegates to bob
    require forall address a. 
        (mirror_propositionDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=PROPOSITION_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );

    requireInvariant user_cant_proposition_delegate_to_himself();
    requireInvariant inv_proposition_power_correct(bob);

    f(e,args);
    
    require forall address a. 
        (mirror_propositionDelegatee[a] != bob ||
         (mirror_delegationMode[a]!=PROPOSITION_DELEGATED() &&
          mirror_delegationMode[a]!=FULL_POWER_DELEGATED()
         )
        );

    uint256 bob_bal_after = balanceOf(bob);
    mathint bob_power_after = getPowerCurrent(bob, PROPOSITION_POWER());
    bool is_bob_delegating_after = isDelegatingProposition(bob);
    mathint bob_diff = bob_bal_after - bob_bal_before;

    require (is_bob_delegating_before == is_bob_delegating_after);
    
    assert !is_bob_delegating_after => bob_power_after==bob_power_before + bob_diff;
    assert is_bob_delegating_after => bob_power_after==bob_power_before;
}

