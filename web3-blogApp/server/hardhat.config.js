require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.9",

  //configuration for the local network
  //chainId is 1337 because we are using metamask and by default localhost of metamask has 1337 chainId
  //for local test network
  networks: {
    hardhat: {
      chainId: 1337,
    },


    //for polygon network
    //configuration for polygon network cause we are our deploying our contract to polygon
    // polygon: {
    //   url: "https://polygon-rpc.com/",
    //   account: [process.env.pk],
    // },
  },
};
