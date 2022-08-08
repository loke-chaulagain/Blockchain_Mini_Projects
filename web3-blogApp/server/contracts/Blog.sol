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
    event PostUpdated(uint256 id, string title, string hash, bool published);

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

    //Fetch an individual post function by content hash //it will return a single post based on a hash that it is deployed to.
    function fetchPost(string memory hash) public view returns (Post memory) {
        return hashToPost[hash];
    }

    //Creating a new post function //onlyOwner is the modifer that gives permission to onlt yhe owner
    //while creatinfg a post it takes two parameter title and hash
    function createPost(string memory title, string memory hash)
        public
        onlyOwner
    {
        _postIds.increment(); //incrementing the post id as we create a new post //the first post have post id of 1.
        uint256 postId = _postIds.current();
        Post storage post = idToPost[postId];
        post.id = postId;
        post.title = title;
        post.published = true;
        post.content = hash;
        hashToPost[hash] = post; //hash to post mapping
        emit PostCreated(postId, title, hash); //everytime a new post will be created this event will be fired.
    }

    //Update an existing post function
    function updatePost(
        uint256 postId,
        string memory title,
        string memory hash,
        bool published
    ) public onlyOwner {
        Post storage post = idToPost[postId]; //lookup post using postId
        post.title = title;
        post.published = published;
        post.content = hash;
        idToPost[postId] = post; //updating idToPost mapping
        hashToPost[hash] = post; //updating hashToPost mapping
        emit PostUpdated(post.id, title, hash, published);
    }

    //Fetch all Posts function
    function fetchPost() public view returns (Post[] memory) {
        uint256 itemCount = _postIds.current(); //finding the size of an array because that is the number of post created
        
        Post[] memory posts = new Post[](itemCount); //creating new Post array and returning that
        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            Post storage currentItem = idToPost[currentId];
            posts[i] = currentItem;
        }
        return posts;
    }

    //This modifier means only teh contract owner can invoke the function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

//This contract allows the owner to create and edit posts, and for anyone to fetch posts.
//To make this smart contract permissionless, you could remove the onlyOwner modifier and use The Graph to index and query posts by owner.
