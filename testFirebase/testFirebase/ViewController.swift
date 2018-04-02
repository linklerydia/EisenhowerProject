//
//  ViewController.swift
//  testFirebase
//
//  Created by David TANG on 2/3/18.
//  Copyright © 2018 David TANG. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate  {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("sortir")
    }
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func googlelogout(_ sender: Any) {

        GIDSignIn.sharedInstance().signOut()
        print("sign out google")
    }
    @IBAction func facebooklogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("sign out facebook")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        signup()
    }
    @IBAction func signin(_ sender: Any) {
        signin()
    }
    @IBAction func google(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func facebook(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    
                    return
                }
                
                // Present the main view
                print("Login facebook succefull")

                
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func signup() {
        guard let email = email.text else {
            print("Email is empty")
            return
        }
        guard let password = password.text else {
            print("Password is empty")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            } else {
                print("SIGN UP SUCCESSFULL")
            }
            guard let uid = user?.uid else {
                return
            }
        })
    }
    
    private func signin() {
        guard let email = email.text else {
            print("Email is empty")
            return
        }
        guard let password = password.text else {
            print("Password is empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            } else {
                print("SIGN IN SUCCESSFULL")
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print("GOOD")

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
    }

}

