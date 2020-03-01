//
//  LoginViewController.swift
//  CustomLoginDemo
//
//  Created by wang songtao on 2/28/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        // Hide error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }



    @IBAction func backTaped(_ sender: Any) {
        let viewController =
        storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as?
        ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // TODO: Validate Text Fields
        
        //Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                               
                let vc : HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                let navigationController = UINavigationController(rootViewController: vc)
                vc.modalPresentationStyle = .fullScreen
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController,animated: true,completion: nil)
            }
        }
    }
    
}
