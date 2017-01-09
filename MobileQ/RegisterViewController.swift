//
//  RegisterViewController.swift
//  MobileQ
//
//  Created by Kimberly Skipper on 1/3/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController
{
    @IBOutlet weak var regEmailTextField: UITextField!
    @IBOutlet weak var regPasswordTextField: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerUser(_ sender: Any)
    {
        if let email = regEmailTextField.text, let password = regPasswordTextField.text
        {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) {
            user, error in
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                print("user registration successful")
                self.setDisplayName(user!)
            }
        }
        let _ = navigationController?.popViewController(animated: true)

    }
    
    func setDisplayName(_ user: FIRUser)
    {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges() {
            error in
            if let error = error
            {
                print(error.localizedDescription)
                return
            }
            let currentUser = (FIRAuth.auth()?.currentUser!)!
            self.userIsLoggedIn(currentUser)
        }
        
    }
    
    func userIsLoggedIn(_ user: FIRUser)
    {
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.displayName = user.displayName ?? user.email
        dismiss(animated: true, completion: nil)
    }

}// end class
