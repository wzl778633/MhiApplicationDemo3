//
//  UpdateLinkVC.swift
//  CustomLoginDemo
//
//  Created by Tom Wang on 3/1/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import Firebase
class UpdateLinkVC: UIViewController {

    var db : Firestore?
    var type : String?
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
        let db = Firestore.firestore()
        let error = validateFields()
        if error != nil{
            showError(error!)
        }else{
        guard let description = descriptionTextfield.text, !description.isEmpty else {return}
        guard let link = linkTextfield.text, !link.isEmpty else{return}
        guard let name = linkNameTextfield.text, !name.isEmpty else{return}
            if let t = self.type{
                docRef = db.collection(t).document(name)
            }
            
        if let d = docRef{
        d.setData([
            "Description": description,
            "Link": link,
            "Date": Timestamp.init()
        ]){(error) in
            if let error = error{
                self.showError("Error! cannot store this link to database: \(error.localizedDescription)")
            }else {
                //Need to be changed!
               self.showError("Success!")
                self.linkNameTextfield.isUserInteractionEnabled = false
                self.descriptionTextfield.isUserInteractionEnabled = false
                self.linkTextfield.isUserInteractionEnabled = false
                
                
            }
            
        }
        }
        }
    }
    
    func setUpElements(){
            errorLabel.alpha = 0;
           // Style the elements
           Utilities.styleTextField(linkNameTextfield)
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
