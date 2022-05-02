npx hardhat run --network avaxfuji scripts/deployNodeRewardAndToken2.ts
npx hardhat run --network avaxfuji scripts/deployNodeReward.ts
npx hardhat run --network bsctestnet scripts/deployToken.ts

npx hardhat run --network bsctestnet scripts/deployToken.ts

# verify iterable mapping
npx hardhat verify --network bsctestnet 0x16eF1754997bcfEeb3a67bE8624d3A2899b15705 --constructor-args TokenConstructorArguments.js


npx hardhat verify --network bsctestnet  --contract contracts/BridgeBsc.sol:BridgeBsc 0x6EFF4835385b8D683431290356eE668193D18Efe
npx hardhat verify --network bsctestnet  --contract contracts/BridgePolygon.sol:BridgePolygon 0xD69c659ecA6f9305683a0FC1b6772086e7C03c6d

  #* contracts/BridgeBase.sol:BridgeBase
  #* contracts/BridgeBsc.sol:BridgeBsc
  #* contracts/BridgePolygon.sol:BridgePolygon
  #0xA5ed7612b220a71BFB660fD2D4De21bC109f1f3E


# pancake router testnet 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
# busd testnet 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7


npx hardhat verify --network avaxmainnet 0x38040c11C798E69e977ADEDE901376a2319475dB
npx hardhat verify --network avaxmainnet --libraries NODERewardsLibraries.js 0x05c88F67fa0711b3a76ada2B6f0A2D3a54Fc775c

npx hardhat verify --network avaxfuji 0xC41FB7e539FB83062E846CB0360A21b2Ed8ef5d2
npx hardhat verify --network avaxfuji --libraries NODERewardsLibraries.js 0x38AAB080578FC83668546d0a7E2c3636c115cd93

# verify token

npx hardhat verify --network bsctestnet 0x715196c3d05ee1016f408AACF03Af8aF2B26e6A1

npx hardhat verify --network avaxfuji --libraries NODERewardsLibraries.js 0x8BeFeA01F464577F628837e4B7F6497492617392 \
&& npx hardhat verify --network avaxfuji --constructor-args ProjectXArguments.js 0x7F1D2b524B4bBB8B890938708f702526592B4d5F

npx hardhat verify --network avaxfuji --constructor-args ProjectXArguments.js 0x9e20Af05AB5FED467dFDd5bb5752F7d5410C832e

    #create create price 10  - 10000000000000000000
    #rewards 1 - 1000000000000000000
    #time 300 - 5 min
    #manager 0x18811df36ac7ec9a06f4a2f11f4642c9466d07f0
    #distribution gas 70000

# npx hardhat verify --network bsctestnet 0x89808EE99894Ec865D5532245b9b9E2d89Be1A7b
# 
# 0xb941ec0048AAe6058C774b5c832f59a5F9334855

# npx hardhat run --network avaxfuji scripts/deployNodeReward.ts
#npx hardhat run --network avaxfuji scripts/deployNodeRewardAndToken2.ts
#npx hardhat run --network avaxfuji scripts/deployToken.ts
#npx hardhat run --network avaxfuji scripts/deployPresaleSender.ts
#npx hardhat run --network avaxfuji scripts/deployToken.ts
#npx hardhat verify --network avaxfuji --constructor-args ProjectXArguments.js 0x01f7e8E641A7dC2cA41B72041ac7cE6dd1f8Ecb3


# npx hardhat verify --network avaxfuji 0xf2a2CeAAB02aEC08F7FB0f642d52e86321A85907 10 1 300
# npx hardhat verify --network avaxfuji --constructor-args ProjectXArguments.js 0xeD7BbA6606dd02254BE43191Deb08d72B3d2173D
# npx hardhat verify --network avaxfuji 0xDD62870d93441A6dd84d54195BE06f5C41228E66 10 1
# npx hardhat verify --network avaxfuji --constructor-args ProjectXArguments.js 0x893d02d7b1a4c52b24a77f5b3e5c4e4ddbd5f3e6


#  --libraries ProjectXLibraries.js
# npx hardhat verify --network avaxfuji --constructor-args ProjectXArguments.js --libraries ProjectXLibraries.js 0x3265dF14E7c5F45141a738A27e4A4270Cd037d4F

# npx hardhat verify --network avaxfuji  0x2d0a4345bd97bc84e915676f64acfa4a745bc650 100000000000000000000 1000000000000000000 180


    #routerAddress = w3.toChecksumAddress("0x7E3411B04766089cFaa52DB688855356A12f05D1") hurricaneswap fuji
    #routerAddress = w3.toChecksumAddress("0x2D99ABD9008Dc933ff5c0CD271B88309593aB921") # pangolin fuji
    #routerAddress = w3.toChecksumAddress("0x60aE616a2155Ee3d9A68541Ba4544862310933d4") # traderjoe main
    routerAddress = w3.toChecksumAddress("0x5db0735cf88F85E78ed742215090c465979B5006") # traderjoe fuji