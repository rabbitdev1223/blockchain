import hardhat, {ethers} from 'hardhat'
import fs from "fs";

async function main() {

    const networkName = hardhat.network.name as 'rinkeby' | 'bscTestnet' | 'bsc'

    const [deployer] = await ethers.getSigners()

    if (deployer === undefined) throw new Error('Deployer is undefined.')

    console.log('Deploying contracts with the account:', deployer.address)
    console.log('Account balance:', (await deployer.getBalance()).toString())

    // payment Token
    const PaymentToken = await ethers.getContractFactory('PaymentToken')

    const paymentTokenArgs: any[] = []

    const paymentTokenContract = await PaymentToken.deploy(...paymentTokenArgs)

    console.log('PaymentToken:', paymentTokenContract.address)

    // NFT contract

    const NftToken = await ethers.getContractFactory('NftToken')

    const nftTokenArgs: any[] = []

    const nftTokenContract = await NftToken.deploy(...nftTokenArgs)

    console.log('NftToken:', nftTokenContract.address)

    // marketplace contract

    const Marketplace = await ethers.getContractFactory('Marketplace')

    const marketplaceArgs = [
        paymentTokenContract.address,
        nftTokenContract.address
    ]

    const marketPlaceContract = await Marketplace.deploy(...marketplaceArgs)
    console.log('MarketPlace:', marketPlaceContract.address)

    const contractsParams = [
        {
            name: 'paymentToken',
            contract: paymentTokenContract,
            arguments: paymentTokenArgs,
        },
        {
          name: 'NftToken',
          contract: nftTokenContract,
          arguments: nftTokenArgs,
        },
        {
          name: 'MarketPlace',
          contract: marketPlaceContract,
          arguments: marketplaceArgs,
        },
    ]

    const scanURI = {
        rinkeby: 'https://rinkeby.etherscan.io',
        bscTestnet: 'https://testnet.bscscan.com',
        bsc: 'https://bscscan.com',
        avaxTestnet: 'https://speedy-nodes-nyc.moralis.io/6b6699a56d6c765982b4b7c0/avalanche/testnet'
    }

    await fs.appendFileSync(
        `./deployed.log`,
        `\n## ${networkName} (${new Date()})\n`,
    )

    for (let i = 0; i < contractsParams.length; i++) {
        const params: any = contractsParams[i]
        console.log(
            `${params.name} deployed to: ${scanURI[networkName]}/address/${params.contract.address}#code`,
        )
        // Write the arguments
        await fs.writeFileSync(
            `./arguments/argument-${params.name}-${networkName}.ts`,
            `export default ${JSON.stringify(params.arguments)}`,
        )

        await fs.appendFileSync(
            `./deployed.log`,
            `${params.name}: ${scanURI[networkName]}/address/${params.contract.address}#code\n` +
            `npx hardhat verify --network ${networkName} ${params.contract.address} --constructor-args ./arguments/argument-${params.name}-${networkName}.ts\n`,
        )
    }
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

// 0x2D99ABD9008Dc933ff5c0CD271B88309593aB921


/*
Address:      0xcF2370872F7628b3e41c3A6e30b5BA9cfE95CdF9
Private Key:  e2a51d2a8323e806b7c334665b60ec6a3633f628856fc88438f44dde5b1092ae


Address:      0x7A260df520bEFe9217EB546a3232f4Df11138423
Private Key:  2c6f097a8cd842c2ee7811d5ae5180142aa30525ea3db3362032bbea47acf121

*/