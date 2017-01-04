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
    @IBOutlet weak var  regDisplayNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // separage the email "ben" and "the ironyard.com".  Ben gets saved and the ironyard.com get thrown away.
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
