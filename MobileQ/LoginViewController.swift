//
//  LoginViewController.swift
//  MobileQ
//
//  Created by Kimberly Skipper on 1/3/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func processLogin(_ sender: Any)
    {
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            FIRAuth.auth()?.signIn(withEmail: email, password: password)
            {
                user, error in
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                print("user logged in successfully")
                self.userIsLoggedIn(user!)
                
                
            }
        }
    }
    
    
   @IBAction func gotoRegister(_ sender: UIButton!)
   {                                  
        performSegue(withIdentifier: "ModalRegisterSegue", sender: self)
   }
    
    



    func userIsLoggedIn(_ user: FIRUser)
    {
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.displayName = user.displayName ?? user.email
        dismiss(animated: true, completion: nil)
    }
    
}//end class
