//
//  ViewController.swift
//  xBeacon
//
//  Copyright © 2016 BaDaSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    // Constants
    var rootRef = FIRDatabase.database().reference()
    // Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions
    @IBAction func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func loginDidTouch(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
            
            if error == nil {
                
                FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
                    if let user = user {
                        print("User is signed in with uid:", user.uid)
                    } else {
                        print("No user is signed in.")
                    }
                }
                
                // Go to main screen
                self.performSegueWithIdentifier("Login", sender: self)
                
            }
            else {
                
            }
            
        }

    }
    
    // Creating a new user to Firebase
    @IBAction func signUpDidTouch(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register for an xBeacon account.",
                                      preferredStyle: .Alert)
        
        // Save the new user and assign unique major and minor values to them.
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default) { (action: UIAlertAction) -> Void in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                                            if error == nil {
                                                
                                                FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
                                                    if let user = user {
                                                        print("User is signed in with uid:", user.uid)
                                                    } else {
                                                        print("No user is signed in.")
                                                    }
                                                }
                                                
                                                //Setup major minor for this user
                                                
                                                FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text! ) { (user, error) in
                                                }
                                                
                                                self.performSegueWithIdentifier("Login", sender: self)

                                            }
                                        }
                                        
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }


}

