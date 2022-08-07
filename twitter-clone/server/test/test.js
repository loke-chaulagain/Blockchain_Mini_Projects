//To test our contract, we are going to use Hardhat Network, a local Ethereum network designed for development.
//Hardhat is a tool that allows you to run your contracts locally and test them.
//Chai is a JavaScript library that provides a simple way to write assertions in JavaScript.

//In our tests we're going to use ethers.js to interact with the Ethereum contract &   we'll use Mocha as our test runner.

const { expect } = require("chai");
// const { ethers } = require("hardhat");

const {ethers}=require("hardhat/config");

//describe is the group &  Twitter Contract is the test name
//This is our main test method where all others test methods lies here
describe("Twitter Contract", function () {
  let Twitter;
  let twitter;
  let owner;
  const NUM_TOTAL_NOT_MY_TWEETS = 5;
  const NUM_TOTAL_MY_TWEETS = 3;
  //So we have total 8 tweets on blockchain
  let totalTweets;
  let totalMyTweets;

  //Before each unit test, we need to deploy the contract
  beforeEach(async function () {
    //Get the contract instance from the provider
    Twitter = await ethers.getContractFactory("TwitterContract");

    //create a new instance
    twitter = await Twitter.deploy();

    //Get the address of the owner and other users that are signed in in Twitter
    //A Signer in ethers.js is an object that represents an Ethereum account.
    [owner, addr1, addr2] = await ethers.getSigners(); //here owner means owner address and addr1 & and addr2 means other users address
    //We used this because 3 tweets are our rest 5 are done bt other users

    //initialize total tweets and total my tweets
    totalTweets = [];
    totalMyTweets = [];

    //Creating 5 dummy tweet not my tweets with owner address addr1
    for (let i = 0; i < NUM_TOTAL_NOT_MY_TWEETS; i++) {
      let tweet = {
        tweetText: "Random text with id " + i,
        username: addr1,
        isDeleted: false,
      };

      await twitter.connect(addr1).addTweet(tweet.tweetText, tweet.isDeleted);
      totalTweets.push(tweet);
    }

    //Creating 3 my tweets with my id (owner address)
    for (let i = 0; i < NUM_TOTAL_MY_TWEETS; i++) {
      let tweet = {
        tweetText: "Random text with id " + (NUM_TOTAL_NOT_MY_TWEETS + i),
        username: owner,
        isDeleted: false,
      };

      await twitter.connect(addr1).addTweet(tweet.tweetText, tweet.isDeleted);
      totalTweets.push(tweet);
      totalMyTweets.push(tweet);
    }
  });

  //Test 1 :Creating new tweet
  describe("Add Tweet", function () {
    it("should emit AddTweet event", async function () {
      let tweet = {
        tweetText: "New tweet dummy text",
        isDeleted: false,
      };

      expect(
        await twitter
          .addTweet(tweet.tweetText, tweet.isDeleted)
          .to.emit(twitter, "AddTweet")
          .withArgs(
            owner.address,
            NUM_TOTAL_NOT_MY_TWEETS + NUM_TOTAL_MY_TWEETS
          )
      );
    });
  });

  //Test 2 : Get all tweets
  describe("Get All Tweets", function () {
    it("Should return the correct number of total tweets", async function () {
      const tweetsFromChain = await twitter.getAll();
      expect(tweetsFromChain.length).to.equal(
        NUM_TOTAL_NOT_MY_TWEETS + NUM_TOTAL_MY_TWEETS
      );
    });
    //Test 3 : checking no of MY tweets(3)
    it("should return the correct number of my all tweets", async function () {
      const myTweetsFromChain = await twitter.getMyTweets();
      expect(myTweetsFromChain.length).to.equal(NUM_TOTAL_MY_TWEETS);
    });
  });

  //Test 4 : Deleting my tweets
  describe("Delete Tweets ", function () {
    it("should emit delete tweets event ", async function () {
      const TWEET_ID = 0;
      const TWEET_DELETED = true;
      //addr1 added 3 tweets so only addr1 can delete that tweets
      await expect(twitter.connect(addr1).deleteTweet(TWEET_ID, TWEET_DELETED))
        .to.emit(twitter, "DeleteTweet")
        .withArgs(TWEET_ID, TWEET_DELETED);
    });
  });
});
