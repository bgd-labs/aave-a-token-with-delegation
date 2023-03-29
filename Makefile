# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes --via-ir
test   :; forge test -vvv

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md


storage-diff :
	forge inspect etherscan/AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol:AToken storage-layout --pretty > reports/AToken_layout.md
	forge inspect src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation storage-layout --pretty > reports/ATokenWithDelegation_layout.md
	make git-diff before=reports/AToken_layout.md after=reports/ATokenWithDelegation_layout.md out=AToken_WithDelegation_layout_diff
