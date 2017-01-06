//
//  ViewController.swift
//  MobileQ
//
//  Created by Kimberly Skipper on 1/3/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase

class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
      
    @IBOutlet weak var tableView: UITableView!
    

    
    var dbRef: FIRDatabaseReference!
    fileprivate var refHandle: FIRDatabaseHandle!
    var requests = Array<Request>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Mobile Q"
        
        configureDatabase()
        
// NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !AppState.sharedInstance.signedIn
        {
            performSegue(withIdentifier: "ModalLoginSeque", sender: self)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Firebase methods
    
    deinit
    {
        self.dbRef.child("question").removeObserver(withHandle: refHandle)
    }
    
    func configureDatabase()
    {
        dbRef = FIRDatabase.database().reference()
//        refHandle = dbRef.child("requests").observe(.childAdded, with: {(snapshot) -> Void in
//            //must use self. in closure
////            self.requests.append(snapshot)
//            let indexPath = IndexPath(row: self.requests.count - 1, section: 0)
//            // what does this line mean
//            self.tableView.insertRows(at: [indexPath], with: .automatic)
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        })
    }
    //add func FIRDataEventTypeChildRemoved for student to be able to remove from Queue
    
    //MARK: - table view data source

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueueCell", for: indexPath) as! QueueTableViewCell
        
        let aRequest = requests[indexPath.row]
        if let description = aRequest.description, let name = aRequest.name
        {
            cell.subjectTextField.text = ("\(description)")
            cell.nameLabel.text = ("\(name)")
        }
        else
        {
            aRequest.name = AppState.sharedInstance.displayName!
            cell.subjectTextField.becomeFirstResponder()
        }
//        let question = requestSnapshot.value as! Dictionary<String, Any>
//        if let name =  question["name"] as? String, let subject = question["subject"] as? String, let status = question["status"] as? Bool
           // let description = question["description"],
           // let status = question["status"]
        return cell
    }
    
    //MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.text != ""
        {
            let contentView = textField.superview
            let cell = contentView?.superview as! QueueTableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let aRequest = requests[indexPath.row]
            aRequest.description = textField.text
            aRequest.name = AppState.sharedInstance.displayName
            aRequest.done = false
            textField.resignFirstResponder()
            
//            let questionData = ["name": username!, "subject": question!, "status": false] as [String: Any]
        
            aRequest.sendToFirebase()
            //subjectTextField.text = ""
            
            
           // textField.isFirstResponder
        }
        return false
    }
    
    
    
    //MARK: - Helper Functions
    
//    func keyboardWillShow(_ notification: Notification)
//    {
//        let height = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue) .cgRectValue.height) + 4
//        questionTextFieldConstraint.constant = height
//    }
//    
//    func keyboardDidHide(_ notification: Notification){
//        questionTextFieldConstraint.constant = 8.0
//    }
    
//    func sendRequest()
//    {
//        if let question = subjectTextField.text
//        {
//            if let username  = AppState.sharedInstance.displayName
//            {
//                let questionData = ["subject": question, "name": username,"status": false] as [String : Any]
//                dbRef.child("requests").childByAutoId().setValue(questionData)
//                subjectTextField.text = ""
//                }
//            }
//        }
    
    

    
    //MARK - Action Handlers
    
    @IBAction func addRequestToList(_ sender: UIBarButtonItem)
    {
        let newRequest = Request()
        requests.append(newRequest)
        tableView.reloadData()
//        if let subject = subjectTextField.text
//        {
//           
//            let question = ["name": AppState.sharedInstance.displayName!, "subject": "", "status": false] as? [String: Any]
//            dbRef.child("requests").childByAutoId().setValue(question)
//        
//        }
        
    }

    
        
        //let indexPath = tableView.indexPath(for: cell)
        
        //tableView.insertRows(at: [IndexPath(row: requests.count - 1, section: 0)], with: .automatic)
    
    
//    @IBAction func sendButtonWasTapped(_ sender: UIButton)
//    {
//        //create request object
//        sendRequest()
//        
//    }
    
//    @IBAction func hideKeyboardButton(_ sender: UIButton)
//    {
//        if subjectTextField.isFirstResponder
//        {
//            subjectTextField.resignFirstResponder()
//        }
//    }
    
    
    
// @IBAction func boxWasPressed(_ sender: UIButton)
//    {
//        let contentView = sender.superview
//        let cell = contentView?.superview as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        //let indexPath = tableView.indexPath(for: cell)
//        let aQuestion = requests[indexPath!.row]
//        let isDone = true
//        if !aQuestion
//        {
//            aQuestion = true
//            sender.setImage(UIImage(named: "boxchecked"), for: .normal)
//        }
//        else
//        {
//            aQuestion.done = false
//            sender.setImage(UIImage(named: "unchecked box"), for: .normal)
//        }
//    
//    }


}// end class
