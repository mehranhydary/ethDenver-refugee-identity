var RefugeeIdentity = artifacts.require("./contracts/RefugeeIdentity.sol");

module.exports = function (deployer) {
  deployer.deploy(RefugeeIdentity);
};
