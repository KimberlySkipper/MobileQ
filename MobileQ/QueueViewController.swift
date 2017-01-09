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
    @IBOutlet weak var tableViewBottomContraint: NSLayoutConstraint!
    

    
    var dbRef: FIRDatabaseReference!
    fileprivate var refHandle: FIRDatabaseHandle!
    var requests = Array<Request>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Mobile Q"
        
        configureDatabase()
        
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !AppState.sharedInstance.signedIn
        {
            performSegue(withIdentifier: "ModalLoginSeque", sender: self)
        }
        tableView.reloadData()

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
        refHandle = dbRef.child("requests").observe(.childAdded, with: {(snapshot) -> Void in
           // print(snapshot.value)
           //must use self. in closure
            let req = Request.createRequestFromJsonDictionary(snapshot.value as! [String : Any])
            req?.key = snapshot.key
            self.requests.append(req!)
        let indexPath = IndexPath(row: self.requests.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
      })
        
    }
    
    
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
        //let requestSnapshot: FIRDataSnapshot! = requests[indexPath.row]
        //let question = requestSnapshot.value as! Dictionary<String, Any>
        let aRequest = requests[indexPath.row]
        
        if let description = aRequest.description, let name = aRequest.name
        {
            cell.subjectTextField.text = ("\(description)")
            cell.nameLabel.text = ("\(name)")
            if description.isEmpty
            {
                cell.subjectTextField.becomeFirstResponder()
            }
        }
        if aRequest.done!
        {
            aRequest.done = true
            cell.checkboxButton.setImage(#imageLiteral(resourceName: "checked box"), for: .normal)
        } else {
            aRequest.done = false
            cell.checkboxButton.setImage(#imageLiteral(resourceName: "unchecked box"), for: .normal)
        }
        


        
//        let question = requestSnapshot.value as! Dictionary<String, Any>
//        if let name =  question["name"] as? String, let subject = question["subject"] as? String, let status = question["status"] as? Bool
           // let description = question["description"],
           // let status = question["status"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //FIXME: deleting cell func not working
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            //let aRequest = requests[indexPath.row]
            requests.remove(at: indexPath.row).deleteFromFirebase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
           // requests.remove(at: indexPath.row)
            aRequest.sendEditToFirebase()
            //subjectTextField.text = ""
            
            
           // textField.isFirstResponder
        }
        return false
    }
    
    
    
    //MARK: - Helper Functions
    
    func keyboardWillShow(_ notification: Notification)
    {
        let height = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue) .cgRectValue.height) + 4
        tableViewBottomContraint.constant = height
    }
    
    func keyboardDidHide(_ notification: Notification){
        tableViewBottomContraint.constant = 8.0
    }
    
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
        newRequest.description = "";
        newRequest.name = AppState.sharedInstance.displayName
        newRequest.sendToFirebase()
        tableView.reloadData()
        //tableView.insertRows(at: [IndexPath(row: requests.count - 1, section: 0)], with: .automatic)
//        if let subject = subjectTextField.text
//        {
//           
//            let question = ["name": AppState.sharedInstance.displayName!, "subject": "", "status": false] as? [String: Any]
//            dbRef.child("requests").childByAutoId().setValue(question)
//        
//        }
        
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem)
    {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
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
    
    
    
 @IBAction func boxWasPressed(_ sender: UIButton)
    {
        let contentView = sender.superview
        let cell = contentView?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        //let indexPath = tableView.indexPath(for: cell)
        let aRequest = requests[indexPath!.row]
        
        if aRequest.done!
        {
            aRequest.done = false
            // sender.setImage(UIImage(named: "box checked"), for: .normal)
        }
        else
        {
            aRequest.done = true
            // sender.setImage(UIImage(named: "unchecked box"), for: .normal)
        }
        aRequest.sendEditToFirebase()
        tableView.reloadData()
        
    }


}// end class
