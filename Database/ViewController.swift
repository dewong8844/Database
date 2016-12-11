//
//  ViewController.swift
//  Database
//
//  Created by Dennis Wong on 11/13/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var databasePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field's user input through delegate callbacks.
        name.delegate = self
        address.delegate = self
        phone.delegate = self

        initContactsDB()
    }
    
    // MARK: Initialization
    
    func initContactsDB() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("contacts.db").path
        if !filemgr.fileExists(atPath: databasePath as String) {
        
            // copy initial version of contacts.db file from main bundle
            let bundlePath = Bundle.main.path(forResource: "contacts", ofType: ".db")
            if bundlePath == nil {
                print ("Error: unable to find contacts.db in main bundle")
                return
            }
            // copy file from main bundle to Documents directory
            do {
                try filemgr.copyItem(atPath: bundlePath!, toPath: databasePath)
                print("Copy file from \(bundlePath) to \(databasePath)")
            }
            catch {
                print("\n")
                print(error)
            }

            let contactDB = FMDatabase(path: databasePath as String)
            if contactDB == nil {
                print ("Error \(contactDB?.lastErrorMessage())")
                status.text = "New fmdb failed"
            }
            
            if (contactDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS contacts (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !(contactDB?.executeStatements(sql_stmt))! {
                    print ("Error \(contactDB?.lastErrorMessage())")
                    status.text = "Create contacts table failed"
                }
                contactDB?.close()
            }
            else {
                print ("Error \(contactDB?.lastErrorMessage())")
                status.text = "Open contacts.db failed"
            }
        }
        else {
            print ("contacts.db found and ready to go")
            status.text = "Contact DB is ready to use"
        }
        
        name.returnKeyType = .done
        address.returnKeyType = .done
        phone.returnKeyType = .done
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }

    // MARK: Actions
    @IBAction func saveData(_ sender: UIButton) {
        let contactDB = FMDatabase(path: databasePath as String)
        if (contactDB?.open())! {
            let querySQL = "SELECT address, phone FROM contacts WHERE name = '\(name.text!)'"
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                let updateSQL = "UPDATE contacts SET address='\(address.text!)', phone='\(phone.text!)' WHERE name='\(name.text!)'"
                let result = contactDB?.executeUpdate(updateSQL, withArgumentsIn: nil)
                if !result! {
                    status.text = "Failed to update contact"
                    print ("Error \(contactDB?.lastErrorMessage())")
                }
                else {
                    status.text = "Contact Updated"
                    name.text = ""
                    address.text = ""
                    phone.text = ""
                }
            }
            else {
                let insertSQL = "INSERT INTO contacts (name, address, phone) VALUES ('\(name.text!)', '\(address.text!)', '\(phone.text!)')"
                let result = contactDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !result! {
                    status.text = "Failed to add contact"
                    print ("Error \(contactDB?.lastErrorMessage())")
                }
                else {
                    status.text = "Contact Added"
                    name.text = ""
                    address.text = ""
                    phone.text = ""
                }
            }
            contactDB?.close()
        }
        else {
            print ("Error \(contactDB?.lastErrorMessage())")
        }
    }

    @IBAction func findContact(_ sender: UIButton) {
        let contactDB = FMDatabase(path: databasePath as String)
        if (contactDB?.open())! {
            let querySQL = "SELECT address, phone FROM contacts WHERE name = '\(name.text!)'"
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                status.text = "Record found"
                address.text = results?.string(forColumn: "address")
                phone.text = results?.string(forColumn: "phone")
            }
            else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            contactDB?.close()
        }
        else {
            print ("Error \(contactDB?.lastErrorMessage())")
        }
    }

    @IBAction func deleteContact(_ sender: UIButton) {
        let contactDB = FMDatabase(path: databasePath as String)
        if (contactDB?.open())! {
            let deleteSQL = "DELETE FROM contacts WHERE name = '\(name.text!)'"
            let result = contactDB?.executeUpdate(deleteSQL, withArgumentsIn: nil)
            if !result! {
                status.text = "Failed to delete contact"
                print ("Error \(contactDB?.lastErrorMessage())")
            }
            else {
                status.text = "Contact Deleted"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
            contactDB?.close()
        }
        else {
            print ("Error \(contactDB?.lastErrorMessage())")
        }
    }
}

