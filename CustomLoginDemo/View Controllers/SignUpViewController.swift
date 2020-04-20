//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by wang songtao on 2/28/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide error label
        errorLabel.alpha = 0;
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true;
        Utilities.styleFilledButton(signUpButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // Check the fields and validate that data is correct. If everything is correct,
    //this method returns nil. Otherwise, it returns the errmessage
    func validateFields() -> String? {
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields. "
        }
        
        // Check if the password is sercure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            // Password isn't secure enough
            return "Please make sure your password is at least 8 character, containing a speicial character and a number"
        }
        return nil
    }
    
    
    @IBAction func backTaped(_ sender: Any) {
        let viewController =
        storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as?
        ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        if error != nil{
            // There;s something wrong witht the fields, show error message
            showError(error!)
        }
        else{
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Create the user
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if  err != nil{
                    // There was an error creating the user
                    self.showError("Error creating the user")
                } else{
                    // User was created successfully, now store the firstname and lastname
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData( ["firstName": firstName,
                    "lastName" : lastName, "userID": result!.user.uid]){ (error) in
                            if error != nil {
                                // Show error message
                                self.showError("Error saving user data")
                            }
                            
                            // Transition to the home screen
                            
                            }
                    let vc : ViewController = self.storyboard?.instantiateViewController(withIdentifier: "VC") as! ViewController
                    let navigationController = UINavigationController(rootViewController: vc)
                    vc.modalPresentationStyle = .fullScreen
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController,animated: true,completion: nil)
                }
            }
            //Transition to the home scrren
        }
        
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    

}
