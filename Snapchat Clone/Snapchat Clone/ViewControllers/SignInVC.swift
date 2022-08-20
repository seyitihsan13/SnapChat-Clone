//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by İhsan Elkatmış on 3.08.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        let btn2 = UIButton()
        
        btn2.layer.cornerRadius = btn2.frame.size.height/2
           btn2.layer.borderWidth = 1
        
        
        if passwordText.text != "" && emailText.text != "" {

            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
            
            
        } else {
            self.makeAlert(title: "Error", message: "Username/Password/Email?")

        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {

        let btn = UIButton()
        
        btn.layer.cornerRadius = btn.frame.size.height/2
           btn.layer.borderWidth = 1
        
            
            
        
        if userNameText.text != "" && passwordText.text != "" && emailText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.emailText.text!,"username" : self.userNameText.text!] as [String : Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            //
                        }
                    }
                    
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
            
            
            
            
        } else {
            self.makeAlert(title: "Error", message: "Username/Password/Email?")
        }
        
    }
    
    
    
    
    
    func makeAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

