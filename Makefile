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
	forge inspect lib/aave-v3-factory/src/core/contracts/protocol/tokenization/AToken.sol:AToken storage-layout --pretty  > reports/AToken_layout.md
	forge inspect src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation storage-layout --pretty > reports/ATokenWithDelegation_layout.md
	make git-diff before=reports/AToken_layout.md after=reports/ATokenWithDelegation_layout.md out=AToken_WithDelegation_layout_diff

code-diff :
	make git-diff before=lib/aave-v3-factory/src/core/contracts/protocol/tokenization/AToken.sol after=src/contracts/AToken.sol out=AToken_diff
	make git-diff before=lib/aave-v3-factory/src/core/contracts/interfaces/IAtoken.sol after=src/contracts/interfaces/IAToken.sol out=IAToken_diff
	make git-diff before=lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableAToken.sol after=src/contracts/interfaces/IInitializableAToken.sol out=IInitializableAToken_diff
	make git-diff before=lib/aave-v3-factory/src/core/contracts/protocol/tokenization/base/IncentivizedERC20.sol after=src/contracts/IncentivizedERC20.sol out=IncentivizedERC20_diff
	make git-diff before=lib/aave-v3-factory/src/core/contracts/protocol/tokenization/base/MintableIncentivizedERC20.sol after=src/contracts/MintableIncentivizedERC20.sol out=MintableIncentivizedERC20_diff
	make git-diff before=lib/aave-v3-factory/src/core/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol after=src/contracts/ScaledBalanceTokenBase.sol out=ScaledBalanceTokenBase_diff
	make git-diff before=lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol after=src/contracts/dependencies/SafeCast.sol out=SafeCast_diff

deploy-aaave-token :; forge script scripts/DeployAAaveTokenScript.s.sol:DeployAAaveToken --rpc-url mainnet --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
