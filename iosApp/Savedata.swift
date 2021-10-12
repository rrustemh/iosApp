//
//  Savedata.swift
//  iosApp
//
//  Created by labinot on 7/19/20.
//  Copyright © 2020 GrFL. All rights reserved.
//

import UIKit
import SQLite3

class Note: NSObject {
    var id: Int
    var note: String?
    var date:String?
    
    init(id: Int, note: String?,date:String?){
        self.id = id
        self.note = note
        self.date=date
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("notedb.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return
        }
    }
    
    //creating a statement
    private var stmt: OpaquePointer?
    private var db:OpaquePointer?
    
    public func deleteFromDb() -> Void {
        //the insert query
        let queryString = "DELETE FROM Notes WHERE id=(?)"
        
        print("deleting")
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1,Int32(id)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        //executing the query to delete values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting note: \(errmsg)")
            return
        }
        
        print("deleted")
        
        
    }
    public func editRow() -> Void {
        //the insert query
        let queryString = "UPDATE Notes SET note=(?),date=(?) where id=(?)"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, note, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 2, date, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        //binding the parameters
        if sqlite3_bind_int(stmt, 3,Int32(id)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        //executing the query to edit values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting note: \(errmsg)")
            return
        }
        
        print("deleted")
        
        
    }
}

