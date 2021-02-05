const Contract = artifacts.require("Contract");
const Oracle = artifacts.require("Oracle");

module.exports = async (deployer, _network, accounts) => {
  await deployer.deploy(Oracle, [0, accounts[0]]);

  const oracle = await Oracle.deployed();

  await deployer.deploy(Contract, {
    oracleAddress: oracle.address,
    price: "0",
  });
};
