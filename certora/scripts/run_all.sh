

certoraRun certora/conf/AToken.conf --send_only 

certoraRun certora/conf/AToken-problematic-rules.conf --send_only --rule additiveTransfer

certoraRun certora/conf/AToken-problematic-rules.conf --send_only --rule totalSupplyEqualsSumAllBalance

certoraRun certora/conf/token-v3-delegate.conf --send_only 

certoraRun certora/conf/token-v3-erc20.conf --send_only 

certoraRun certora/conf/token-v3-general.conf --send_only 

certoraRun certora/conf/token-v3-community.conf --send_only 



