// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import hardhat
import "../node_modules/hardhat/console.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

//Contract
contract Blog {
    //name and owner of the contract
    string public name;
    address public owner;

    //variable for counter  //_postIds is the variable
    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    //struct for our post //what we are allowing the user to create as a blog post  // just like model schema.
    struct Post {
        uint256 id;
        string title;
        string content; //the content is going to be th ipfs hash of where the post is been stored.
        bool published; //bool published is to show or hide posts that are published or not.
    }

    //mapping //mapping can be seen as hash tables //here we create lookups for posts by id and posts by ipfs hash.
    //For us to be able to find the posts using the postId or the hash to where published on ipfs.
    mapping(uint256 => Post) private idToPost;
    mapping(string => Post) private hashToPost;

    //Event
    // events facilitate communication between smart contracts and their user interfaces.
    //i.e. we can create listeners for events in the client and also use them in The Graph.
    event PostCreated(uint256 id, string title, string hash);
    event postUpdated(uint256 id, string title, string hash, bool published);

    //Constructor
    //when the blog is deployed ,give it a name also set the crator as the owner of the contract.
    constructor(string memory _name) {
        console.log("Deploying Blog with name :", _name);
        name = _name;
        owner = msg.sender; //msg.sender is the person that deploy the contract
    }

    //Function to update the Blog name
    function updateName(string memory _name) public {
        name = _name;
    }

    //Transfer ownership function
    //onlyOwner can call this function and transfer owner ship ..no other can do this
    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    //onlyOwner modifier
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
