//Deploy script will basically tells that get that contract and deploy on etherium blockchain .
//We are using hardhat to deploy the contract.
const main = async () => {
  //It is async because deploying to etherium might takes some times
  //Telling ethers to fetch any solidity file named with TwitterContract
  const contractFactory = await ethers.getContractFactory("TwitterContract"); //get contract to deploy
  const contract = await contractFactory.deploy();
  await contract.deploy();
  console.log("Contract deployed to:", contract.address);
  //Every instance of contract will have its own address
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

//calling the runMain function
runMain();
