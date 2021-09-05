const ERC20Lock = artifacts.require("ERC20Lock");

module.exports = function (deployer) {
  deployer.deploy(ERC20Lock);
};
