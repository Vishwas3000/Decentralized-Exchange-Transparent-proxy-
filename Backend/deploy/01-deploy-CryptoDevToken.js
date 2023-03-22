const { network, ethers } = require("hardhat")
const { verify } = require("../utils/verify")
const { developmentChains } = require("../helper-hardhat-config")

require("dotenv").config()

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deployer } = await getNamedAccounts()
    const { log, deploy } = deployments

    const chainId = network.config.chainId

    const args = []

    log("---------------------------")

    const exchange = await deploy("CryptoDevToken", {
        from: deployer,
        args: args,
        log: true,
        waitConformations: network.config.blockConformations || 1,
    })
    log("---------------------------")

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifing...")
        await verify(nftMarketPlace.address, args)
    }
}

module.exports.tags = ["all", "devToken"]
