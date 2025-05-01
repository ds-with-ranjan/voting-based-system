// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title B2BSupplyChain
 * @dev Implements a basic B2B supply chain tracking system with product verification
 */
contract B2BSupplyChain {
    address public owner;
    
    // Product structure to store relevant information
    struct Product {
        uint256 id;
        string name;
        string manufacturer;
        uint256 manufactureDate;
        address currentOwner;
        Status status;
        mapping(uint256 => TransferRecord) transferHistory;
        uint256 transferCount;
    }
    
    // Transfer record for tracking ownership changes
    struct TransferRecord {
        address from;
        address to;
        uint256 timestamp;
        string location;
    }
    
    // Status of product in supply chain
    enum Status { 
        Manufactured,
        InTransit,
        Delivered,
        Rejected
    }
    
    // Event declarations
    event ProductCreated(uint256 indexed productId, string name, address manufacturer);
    event OwnershipTransferred(uint256 indexed productId, address indexed from, address indexed to, uint256 timestamp);
    event StatusChanged(uint256 indexed productId, Status newStatus);
    
    // Product mapping
    mapping(uint256 => Product) public products;
    uint256 public productCount;
    
    // Constructor
    constructor() {
        owner = msg.sender;
        productCount = 0;
    }
    
    // Modifier to check if sender is product owner
    modifier onlyProductOwner(uint256 _productId) {
        require(products[_productId].currentOwner == msg.sender, "Only the current owner can perform this operation");
        _;
    }
    
    /**
     * @dev Function to register a new product in the supply chain
     * @param _name Name of the product
     * @param _manufacturer Manufacturer details
     * @return Product ID of the newly created product
     */
    function createProduct(string memory _name, string memory _manufacturer) public returns (uint256) {
        productCount++;
        uint256 productId = productCount;
        
        Product storage p = products[productId];
        p.id = productId;
        p.name = _name;
        p.manufacturer = _manufacturer;
        p.manufactureDate = block.timestamp;
        p.currentOwner = msg.sender;
        p.status = Status.Manufactured;
        p.transferCount = 0;
        
        // Record the initial "transfer" (creation)
        p.transferHistory[p.transferCount] = TransferRecord({
            from: address(0), // No previous owner
            to: msg.sender,
            timestamp: block.timestamp,
            location: "Manufacturing Facility"
        });
        p.transferCount++;
        
        emit ProductCreated(productId, _name, msg.sender);
        return productId;
    }
    
    /**
     * @dev Transfer ownership of product to another entity in the supply chain
     * @param _productId ID of the product to transfer
     * @param _to Address of the recipient
     * @param _location Current location during transfer
     */
    function transferOwnership(uint256 _productId, address _to, string memory _location) public onlyProductOwner(_productId) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(_productId <= productCount && _productId > 0, "Product does not exist");
        
        Product storage product = products[_productId];
        
        // Update product owner
        address previousOwner = product.currentOwner;
        product.currentOwner = _to;
        
        // Update status to in transit
        product.status = Status.InTransit;
        
        // Record in transfer history
        product.transferHistory[product.transferCount] = TransferRecord({
            from: previousOwner,
            to: _to,
            timestamp: block.timestamp,
            location: _location
        });
        product.transferCount++;
        
        emit OwnershipTransferred(_productId, previousOwner, _to, block.timestamp);
        emit StatusChanged(_productId, Status.InTransit);
    }
    
    /**
     * @dev Update the status of a product in the supply chain
     * @param _productId ID of the product to update
     * @param _newStatus New status of the product
     */
    function updateStatus(uint256 _productId, Status _newStatus) public onlyProductOwner(_productId) {
        require(_productId <= productCount && _productId > 0, "Product does not exist");
        
        Product storage product = products[_productId];
        product.status = _newStatus;
        
        emit StatusChanged(_productId, _newStatus);
    }
    
    /**
     * @dev Get basic product details
     * @param _productId ID of the product
     * @return name Product name
     * @return manufacturer Manufacturer information
     * @return manufactureDate Date when product was manufactured
     * @return currentOwner Current owner address
     * @return status Current product status
     */
    function getProductDetails(uint256 _productId) public view returns (
        string memory name,
        string memory manufacturer,
        uint256 manufactureDate,
        address currentOwner,
        Status status
    ) {
        require(_productId <= productCount && _productId > 0, "Product does not exist");
        Product storage product = products[_productId];
        
        return (
            product.name,
            product.manufacturer,
            product.manufactureDate,
            product.currentOwner,
            product.status
        );
    }
    
    /**
     * @dev Get transfer record at a specific index
     * @param _productId ID of the product
     * @param _index Index in the transfer history
     * @return from Address that transferred the product
     * @return to Address that received the product
     * @return timestamp Time when transfer occurred
     * @return location Location where transfer took place
     */
    function getTransferRecord(uint256 _productId, uint256 _index) public view returns (
        address from,
        address to,
        uint256 timestamp,
        string memory location
    ) {
        require(_productId <= productCount && _productId > 0, "Product does not exist");
        require(_index < products[_productId].transferCount, "Transfer record does not exist");
        
        TransferRecord storage record = products[_productId].transferHistory[_index];
        
        return (
            record.from,
            record.to,
            record.timestamp,
            record.location
        );
    }
    
    /**
     * @dev Get the number of transfers for a product
     * @param _productId ID of the product
     * @return Number of transfers
     */
    function getTransferCount(uint256 _productId) public view returns (uint256) {
        require(_productId <= productCount && _productId > 0, "Product does not exist");
        return products[_productId].transferCount;
    }
}
