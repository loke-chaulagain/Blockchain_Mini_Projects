// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../node_modules/hardhat/console.sol";

//-->wallet address is the unique id of the user ,it identifies its your account and your tweets.
//-->Actually we cannot delete or remove blocks in blockchain we just show or hide it .
//-->When you execute a function in your smart contract you are executing a transaction
//-->as I said you do not use your private key other than to sign the transactions.

contract TwitterContract {
    //Event
    event AddTweet(address recpient, uint256 tweetId);
    event DeleteTweet(uint256 tweetId, bool isDeleted);

    struct Tweet {
        uint256 id;
        address username; //-->address is the unique id of the user that is (metamask id)
        string tweetTxt;
        bool isDeleted;
    }

    //To store all the tweets in the blockchain privately
    //Private functions and peiivate state variables are only visible for the contract they are defined in and not in derived contracts.
    //But their values can be read freely outside the blockchain by anyone so they don't hide data in that sense.
    Tweet[] private tweets; //array of tweets

    //mappiing of each tweet id to the wallet address of the user who posted it.
    mapping(uint256 => address) tweetToOwner;

    //Method to add a tweet to the blockchain
    //Posting is a write function so  write function takes some etherium as a gas fee .
    //For every write we need to create a new block on blockchain so it takes some gas fee.
    function addTweet(string memory tweetText, bool isDeleted) external {
        uint256 tweetId = tweets.length; //id of the tweet is the length of the array of tweets
        tweets.push(Tweet(tweetId, msg.sender, tweetText, isDeleted));
        tweetToOwner[tweetId] = msg.sender; //mapping of tweet id to the wallet address of the user who posted it.
        emit AddTweet(msg.sender, tweetId); //emit event to notify the user that a tweet has been added to the blockchain.
    }

    //Method to get all the tweets from the blockchain
    //Read function does not require any gas fee
    function getAllTweets() public view returns (Tweet[] memory) {
        //Tweet[] memory temporary is the new variable to fetch all tweets that are not deleted
        Tweet[] memory temporary = new Tweet[](tweets.length);
        uint256 counter = 0;
        //we want to show all tweets that are not deleted so lets check
        for (uint256 i = 0; i < tweets.length; i++) {
            if (tweets[i].isDeleted == false) {
                temporary[counter] = tweets[i];
                counter++;
            }
        }
        //Result
        Tweet[] memory result = new Tweet[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    //Methods to get only my tweets
    //Read function does not require any gas fee
    function getMyTweets() external view returns (Tweet[] memory) {
        //Tweet[] memory temporary is the new variable to fetch all tweets that are not deleted
        Tweet[] memory temporary = new Tweet[](tweets.length);
        uint256 counter = 0;
        //we want to show all tweets of a particular user (tewwt id should belongs to the msg.sender)
        for (uint256 i = 0; i < tweets.length; i++) {
            if (tweetToOwner[i] == msg.sender && tweets[i].isDeleted == false) {
                temporary[counter] = tweets[i];
                counter++;
            }
        }
        //Result
        Tweet[] memory result = new Tweet[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    //Methods to delete a tweet from blockchain
    //Actually we cannot delete or remove blocks in blockchain we just show or hide it .
    //Delete is a write function so any write function takes some etherium as a gas fee .
    //For every write we need to create a new block on blockchain so it takes some gas fee.
    function deleteTweet(uint256 tweetId, bool isDeleted) external {
        //only the owner(msg.sender) can delete the tweet
        if (tweetToOwner[tweetId] == msg.sender) {
            tweets[tweetId].isDeleted = isDeleted;
            emit DeleteTweet(tweetId, isDeleted); //emit event to notify the user that a tweet has been added to the blockchain.
        }
    }
}

//==>Contract is ready
//now we will create deploy script , deploy script will basically tells that get this contract and deploy on etherium blockchaiin
