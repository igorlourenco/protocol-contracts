const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const ExchangeV2 = artifacts.require('ExchangeV2');
const ERC20TransferProxy = artifacts.require('ERC20TransferProxy');
const TransferProxy = artifacts.require('TransferProxy');
const RoyaltiesRegistry = artifacts.require("RoyaltiesRegistry.sol");

let settings = {
	"default": {
		communityWallet: "0xfb571F9da71D1aC33E069571bf5c67faDCFf18e4"
	},
};

function getSettings(network) {
	if (settings[network] !== undefined) {
		return settings[network];
	} else {
		return settings["default"];
	}
}

module.exports = async function (deployer, network) {
	const { communityWallet } = getSettings(network);
	const erc20TransferProxy = await ERC20TransferProxy.deployed()
		.catch(() => deployProxy(ERC20TransferProxy, [], { deployer, initializer: '__ERC20TransferProxy_init' }));
	const transferProxy = await TransferProxy.deployed()
		.catch(() => deployProxy(TransferProxy, [], { deployer, initializer: '__TransferProxy_init' }));
	const royaltiesRegistry = await RoyaltiesRegistry.new();

  await deployProxy(
  	ExchangeV2,
  	[transferProxy.address, erc20TransferProxy.address, 100, 100, communityWallet, royaltiesRegistry.address],
  	{ deployer, initializer: '__ExchangeV2_init' }
  );
};