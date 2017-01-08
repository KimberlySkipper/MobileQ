//
//  Request.swift
//  MobileQ
//
//  Created by Kimberly Skipper on 1/5/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation
import Firebase

class Request
{
    var name: String?
//    var subject: String?
    var description: String?
    var done: Bool?
    var key: String?
    
    var dbRef: FIRDatabaseReference!


    init()
    {
    }
    
    init(studentName: String, question: String, status: Bool )
    {
        self.name = studentName
//        self.subject = subject
        self.description = question
        self.done = status
    }
    
    static func createRequestFromJsonDictionary(_ aDictionaryMadeFromFBDatabase: [String: Any]) -> Request?
   {
    var request: Request?
    if aDictionaryMadeFromFBDatabase.count > 0
    {
        let name = aDictionaryMadeFromFBDatabase["name"] as? String ?? ""
        //let subject = aDictionaryMadeFromFBDatabase["subject"] as? String ?? ""
        let description = aDictionaryMadeFromFBDatabase["subject"] as? String ?? ""
        let done = aDictionaryMadeFromFBDatabase["status"] as? Bool
        request = Request(studentName: name, question: description, status: done!)
    }
    return request
    
    }
    
    
    func sendToFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        
        let questionData: [String: Any] = ["name": name!, "subject": description ?? "", "status": done ?? false]
        dbRef.child("requests").childByAutoId().setValue(questionData)
    }
    
    func sendEditToFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        
        let questionData: [String: Any] = ["name": name!, "subject": description!, "status": done ?? false]
        dbRef.child("requests").child(key!).setValue(questionData)
    }
    
    func deleteFromFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        dbRef.child("requests").child(key!).removeValue()
    }
}//end class



        



