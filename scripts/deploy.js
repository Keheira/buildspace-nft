const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    for(let i = 0; i < 10; i++){
        let txn = await nftContract.makeNFT()
        await txn.wait()
        console.log("NFT #",i)
    }
  }
  
  const runMain = async () => {
    try {
      await main()
      process.exit(0)
    } catch (error) {
      console.log(error)
      process.exit(1)
    }
  }
  
  runMain()