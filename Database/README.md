This project refers to an example app to access a sqlite database from iOS 10 and swift 3, tested on XCode 8.1.

References:
1. http://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_8_Application_using_Swift_and_FMDB

Known Issues:
11/14/16
1. When contacts.db file doesn't exist initially, there is an error
2. Only handle simplest cases, needs improvement to very basic test cases
   a. only inserts, no updates, so same contact name can be inserted more than once
   b. no deletes
3. Auto layout for buttons is incorrect
