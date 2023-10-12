// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

contract Library {
    address public admin;
    
    struct Book {
        string isbn;
        string title;
        uint256 yearCreated;
        string author;
    }
    
    mapping(string => Book) public bookList;
    
    event BookAdded(string indexed isbn);
    event BookUpdated(string indexed isbn);
    event BookRemoved(string indexed isbn);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can access this function");
        _;
    }
    
    constructor() {
        admin = msg.sender;
    }
    
    function addBook(string memory _isbn, string memory _title, uint256 _yearCreated, string memory _author) public onlyAdmin {
        require(bytes(bookList[_isbn].isbn).length == 0, "Book with this ISBN already exists");
        
        Book memory newBook = Book(_isbn, _title, _yearCreated, _author);
        bookList[_isbn] = newBook;
        
        emit BookAdded(_isbn);
    }
    
    function updateBook(string memory _isbn, string memory _title, uint256 _yearCreated, string memory _author) public onlyAdmin {
        require(bytes(bookList[_isbn].isbn).length > 0, "Book with this ISBN not found");
        
        bookList[_isbn].title = _title;
        bookList[_isbn].yearCreated = _yearCreated;
        bookList[_isbn].author = _author;
        
        emit BookUpdated(_isbn);
    }
    
    function removeBook(string memory _isbn) public onlyAdmin {
        require(bytes(bookList[_isbn].isbn).length > 0, "Book with this ISBN not found");
        
        delete bookList[_isbn];
        
        emit BookRemoved(_isbn);
    }
    
    function getBookData(string memory _isbn) public view returns (string memory, string memory, uint256, string memory) {
        require(bytes(bookList[_isbn].isbn).length > 0, "Book with this ISBN not found");
        
        Book memory book = bookList[_isbn];
        return (book.isbn, book.title, book.yearCreated, book.author);
    }
}
