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
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionTextFieldConstraint: NSLayoutConstraint!
    
    var dbRef: FIRDatabaseReference!
    fileprivate var refHandle: FIRDatabaseHandle!
    var questions = Array<FIRDataSnapshot>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureDatabase()
        
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
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
    
    func configureDatabase()
    {
        dbRef = FIRDatabase.database().reference()
        refHandle = dbRef.child("messages").observe(.childAdded, with: {(snapshot) -> Void in
            //must use self. in closure
            self.questions.append(snapshot)
            let indexPath = IndexPath(row: self.questions.count - 1, section: 0)
            // what does this line mean
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
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        
        let questionSnapshot = questions[indexPath.row]
        let question = questionSnapshot.value as! Dictionary<String, String>
        if let name =  question["name"], let subject = question["subject"]
        {
            cell.textLabel?.text = ("\(name): \(subject)")
           
        }
        return cell
    }
    
    
    
    //MARK: - Helper Functions
    
    func keyboardWillShow(_ notification: Notification) {
        let height = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue) .cgRectValue.height) + 4
        questionTextFieldConstraint.constant = height
    }
    
    func keyboardDidHide(_ notification: Notification){
        questionTextFieldConstraint.constant = 8.0
    }
    
    func sendMessage()
    {
        if let question = subjectTextField.text
        {
            if let username  = AppState.sharedInstance.displayName
            {
                let questionData = ["subject": question, "name": username]
                dbRef.child("questions").childByAutoId().setValue(questionData)
                subjectTextField.text = ""
            }
        }
        
    }

    
    //MARK - Action Handlers
    
    @IBAction func sendButtonWasTapped(_ sender: UIButton){
        sendMessage()
    }
    
    @IBAction func hideKeyboardButton(_ sender: UIButton) {
        if subjectTextField.isFirstResponder {
            subjectTextField.resignFirstResponder()
        }
    }
    
    
    
// @IBAction func boxWasPressed(_ sender: UIButton)
//    {
//        let contentView = sender.superview
//        let cell = contentView?.superview as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        //let indexPath = tableView.indexPath(for: cell)
//        let question = questions[indexPath!.row]
//        let isDone = true
//        if !question
//        {
//            aQuestion.done = true
//            sender.setImage(UIImage(named: "checkbox-pressed"), for: .normal)
//        }
//        else
//        {
//            aQuestion.done = false
//            sender.setImage(UIImage(named: "checkbox"), for: .normal)
//        }
//    
//    }


}// end class
