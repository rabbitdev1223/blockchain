require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();
module.exports = {
solidity: "0.8.0",
paths: {
artifacts: './src/artifacts',
},
networks: {
    hardhat: {
      blockGasLimit: 100000000429720 // whatever you want here
    },
    rinkeby: {
        url: "https://rinkeby.infura.io/v3/724a5f49ca5a4626ad50c8ab0e9fb0dd",
        accounts: [`0x${process.env.REACT_APP_PRIVATE_KEY}`]
    }
},
etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "PG792Q9QTMRCMZVV5DT727XW3WX2B9F6XN"
  }
};