Blockchain readme file for Assignment -2

Group Number 6
Team Members:
1. Shreyash Bhardwaj - f20202066@hyderabad.bits-pilani.ac.in
2. Chinmayee Selukar - f20200735@hyderabad.bits-pilani.ac.in
3. Suhani Mahajan - f20201798@hyderabad.bits-pilani.ac.in
4. Nikhil Raj - f20200093@hyderabad.bits-pilani.ac.in

Description:
Our Solidity file consists of two contracts - One for the seller and another for the User. We compile the file and deploy both contracts separately. First, we deploy the Seller contract, which consists of a structure for the Product comprising different attributes like productName, productId, priceOfProduct, itemsAvailable, BuyerWants, and a boolean variable named delivered showing whether the product is delivered or not.
The seller can register their products with their price through the addNewProduct function. All products will be pushed into an array of data-type Products. We have functions like getProductPrice, which return the cost of the product. 

After registering products, we deploy a “user” smart contract with a constructor taking userBalance as a parameter. Users can buy the product by paying the exact amount through the account’s value. The transaction will be reverted if the user fails to enter the exact amount. After buying the product, the product will offload from abc.com, and we will see that a certain number of products will be reserved for the buyer. Money will be deducted from the user but will not reach the e-commerce website until the user confirms its delivery status. Users can confirm/deny delivery using '2' or '0'. After completion of delivery, changes will be reflected in noOfProductsAvailable and userInventory. Dues will be transferred to Seller, and the boolean delivered will change from false to true. If the transaction fails, the Ethereum will be transferred back to the user, and the product will be moved back to the Seller, i.e., the transaction will be reverted. The seller also has a checkAvailability function which checks whether a particular product is available.  
