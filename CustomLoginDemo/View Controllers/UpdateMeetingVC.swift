//
//  UpdateLinkVC.swift
//  CustomLoginDemo
//
//  Created by Tom Wang on 3/1/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UpdateMeetingVC: UIViewController {

    var db : Firestore?
    
    @IBOutlet weak var meetingTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var zoomLinkField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var docRef : DocumentReference!
    var docRef2 : DocumentReference!
    var time : Timestamp!
    let datePicker = UIDatePicker()
   
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        time = Timestamp(date: datePicker.date)
        let currentTime = Timestamp.init()
        if  time.compare(currentTime) == ComparisonResult.orderedAscending{
            self.present(self.alertController2,animated: true,completion: nil)
        }else{
        dateTextField.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
        }
    }
    
    let alertController = UIAlertController(title: "Success!", message: "This link has been successfully added!", preferredStyle: .alert)
    
    let alertController2 = UIAlertController(title: "Error!", message: "This time is not an available time!", preferredStyle: .alert)
    
    override func viewDidLoad() {
          super.viewDidLoad()
        createDatePicker()
          setUpElements()
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {(alertAction) in self.dismissVC()}))
         alertController2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      }
    

    @IBAction func saveTapped(_ sender: UIButton) {
        let db = Firestore.firestore()
        let error = validateFields()
        if error != nil{
            showError(error!)
        }else{
        guard let name = meetingTextField.text, !name.isEmpty else {return}
        guard let link = zoomLinkField.text, !link.isEmpty else{return}
        guard let date = dateTextField.text, !date.isEmpty else{return}
        docRef = db.collection("Meeting").document(name)
            
        if let d = docRef{
        d.setData([
            "Zoom": link,
            "time": time!
        ]){(error) in
            if let error = error{
                self.showError("Error! cannot store this Meeting to database: \(error.localizedDescription)")
            }else {
                //Need to be changed!
                //self.showError("Success!")
                self.meetingTextField.isUserInteractionEnabled = false
                self.zoomLinkField.isUserInteractionEnabled = false
                self.dateTextField.isUserInteractionEnabled = false
                self.present(self.alertController,animated: true,completion: nil)
            }
            
        }
        }
            let user = Auth.auth().currentUser
            if let user = user {
                   let uid = user.uid
                   let email = user.email
                    docRef2 = db.collection("Meeting").document(name).collection("participants").document()
                    if let d2 = docRef2{
                    d2.setData([
                        "Email": email!,
                        "UID": uid
                    ]){(error) in
                        if let error = error{
                            self.showError("Error! cannot store this Meeting to database: \(error.localizedDescription)")
                        }
            }
            
        }
    }
    }
    }
    func dismissVC(){
        self.navigationController?.popViewController(animated: true)
    }
    func setUpElements(){
            errorLabel.alpha = 0;
           // Style the elements
           Utilities.styleTextField(meetingTextField)
           Utilities.styleTextField(dateTextField)
           Utilities.styleTextField(zoomLinkField)

       }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if meetingTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields. "
        }
        
        // Check if the password is sercure
        let url = zoomLinkField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       
        
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
