//
//  UpdateLinkVC.swift
//  CustomLoginDemo
//
//  Created by Tom Wang on 3/1/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import Firebase
class UpdateLinkVC: UITableViewController {


    @IBOutlet weak var linkNameTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var linkTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var docRef : DocumentReference!
    override func viewDidLoad() {
          super.viewDidLoad()

          setUpElements()
          // Do any additional setup after loading the view.
          
      }
    @IBAction func saveTapped(_ sender: UIButton) {
        let error = validateFields()
        if error != nil{
            showError(error!)
        }else{
        guard let description = descriptionTextfield.text, !description.isEmpty else {return}
        guard let link = linkTextfield.text, !link.isEmpty else{return}
        guard let name = linkNameTextfield.text, !name.isEmpty else{return}
        let dataToSave : [String : Any] = ["Description" : description, "Link": link]
        docRef = Firestore.firestore().collection("Contracts").document(name)
        if let d = docRef{
        d.setData(dataToSave){(error) in
            if let error = error{
                self.showError("Error! cannot store this link to database: \(error.localizedDescription)")
            }else {
                //Need to be changed!
               self.showError("Success!")
            }
            
        }
        }
        }
    }
    
    func setUpElements(){
            errorLabel.alpha = 0;
           // Style the elements
           Utilities.styleTextField(descriptionTextfield)
           Utilities.styleTextField(linkTextfield)

       }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if descriptionTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            linkNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            linkTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields. "
        }
        
        // Check if the password is sercure
        let url = linkTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       
        
        if Utilities.isGoodUrl(urlString: url) == false{
            // Password isn't secure enough
            return "Please make sure your link is validate!"
        }
        return nil
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}
