This project refers to an example app to access a sqlite database from iOS 10 and swift 3, tested on XCode 8.1.

References:
1. http://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_8_Application_using_Swift_and_FMDB
2. http://www.theappguruz.com/blog/use-sqlite-database-swift

References, sign and load app to physical iphone device:
1. http://apple.stackexchange.com/questions/206123/xcode-7-develop-for-ios-without-developer-account
2. http://stackoverflow.com/questions/37806538/code-signing-is-required-for-product-type-application-in-sdk-ios-10-0-stic

Known Issues:
11/14/16
1. When contacts.db file doesn't exist initially, there is an error
2. Need to do validation on user data entry
3. Ignore case when comparing text in textfield and DB
4. Fix Auto layout issues, buttons should be side-by-side
