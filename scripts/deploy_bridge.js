import { artifacts } from "hardhat";

const Migrations = artifacts.require("Migrations");
export default function(deployer) {
  deployer.deploy(Migrations);
};

const TokenEth = artifacts.require('ETHToken.sol');
const TokenBnc = artifacts.require('BNCToken.sol');
const BridgeEth = artifacts.require('ETHBridge.sol');
const BridgeBnc = artifacts.require('BNCBridge.sol');

module.exports = async function(deployer, nw, addr) {
  if (nw == "ethTestnet") {
    await deployer.deploy(TokenEth);
    const tokenETH = await TokenEth.deployed();
    await tokenETH.mint(addr[0], 1000);
    await deployer.deploy(BridgeEth, tokenETH.address);
    const bridgeETH = await BridgeEth.deployed();
    await tokenETH.updateAdmin(bridgeETH.address);
  }
  if (nw == "bscTestnet") {
    await deployer.deploy(TokenBnc);
    const tokenBnc = await TokenBnc.deployed();
    await deployer.deploy(BridgeBnc, tokenBnc.address);
    const bridgeBnc = await BridgeBnc.deployed();
    await tokenBnc.updateAdmin(bridgeBnc.address)
  }
}