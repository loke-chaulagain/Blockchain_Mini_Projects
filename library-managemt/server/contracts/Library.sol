// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../node_modules/hardhat/console.sol";

contract Library {
    //event
    event AddBook(address recipient, uint256 bookId);

    //we use structure to use different data types
    struct Book {
        uint256 id;
        string name;
        uint256 year;
        string author;
        bool finished;
    }

    //Book list (memory for all the books that i have read till now)
    Book[] private bookList;

    //mapping (to track which book iis owned by which address/user)
    //mapping of bookid  to the wallet address
    mapping(uint256 => address) bookToOwner;

    //we can see that the public function uses 496 gas, while the external function uses only 261.
    //The difference is because in public functions, Solidity immediately copies array arguments to memory, while external functions can read directly from calldata. Memory allocation is expensive, whereas reading from calldata is cheap.

    //Add a Book
    function addBook(
        string memory name,
        uint256 year,
        string memory author,
        bool finished
    ) external {
        uint256 bookId = bookList.length; //first book id will start from zero
        bookList.push(Book(bookId, name, year, author, finished));

        //book is added lets add to owner map
        bookToOwner[bookId] = msg.sender;
        emit AddBook(msg.sender, bookId);
    }

    //Get finished books

    functon _getBookList(bool finished) private view returns (Book[] memory){
        Book[] memory temporary =new Book[](bookList.length);
        uint count=0;
        for(uint i=o;<bookList.length;i++){
            if (booktoOwner[i]==msg.sender){
                temporary[counter]=bookList[i];
                counter ++;
            }
        }
    }


    function getFinishedBooks() external view returns (Book[] memory){

        return _getBooksLsts(true);
    }
}
