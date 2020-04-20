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

class NewChatVC: UIViewController {

    var db : Firestore?
    
    @IBOutlet weak var meetingTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var selectButton: UIButton!
    var docRef : DocumentReference!
    var docRef2 : DocumentReference!
    var time : Timestamp!
    let datePicker = UIDatePicker()
    var invitees = [UserCell]()
     
    func updateInvite(invitees: [UserCell]){
        self.invitees = invitees
        if self.invitees.count > 1{
            let str = "Selected "+(self.invitees.count-1).description+" invitees"
            selectButton.setTitle(str,for: .normal)
        }else{
            let str = "Select invitees"
            selectButton.setTitle(str,for: .normal)
        }
            
    }
   

    
    let alertController = UIAlertController(title: "Success!", message: "The chat room has been successfully added!", preferredStyle: .alert)
    
    override func viewDidLoad() {
          super.viewDidLoad()
          setUpElements()
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {(alertAction) in self.dismissVC()}))
      }
    


    func randomString(len:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s:String = ""
        for n in (1...10) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        if self.invitees.count == 1{
            self.showError("Error! Must at least select one invitee")
        }else{
            let myself = Auth.auth().currentUser
            let db = Firestore.firestore()
            var name = meetingTextField.text
            if name == ""{

                for x in self.invitees{
                    if name == ""{
                        name! += x.fName + " " + x.lName
                    }else{
                        name! += ", " + x.fName + " " + x.lName
                    }
                }
            }
            
            let id = randomString(len: 16)
            
            var idList = [String]()
            for x in self.invitees{
                idList.append(x.uid)
            }
            docRef = db.collection("chatroom").document(id)
                
            if let d = docRef{
                for x in self.invitees{
                    d.collection("users").addDocument(data: [
                        "uid" : x.uid,
                        "fName" : x.fName,
                        "lName" : x.lName
                    ])
                }
            }
            if let d = docRef{
            d.setData([
                "name": name!
            ]
            ){(error) in
                if let error = error{
                    self.showError("Error! cannot store this chat room to database: \(error.localizedDescription)")
                }else {
                    //Need to be changed!
                    //self.showError("Success!")
                    
                    
                    self.meetingTextField.isUserInteractionEnabled = false
                    self.present(self.alertController,animated: true,completion: nil)
                    
                    

                    
                    
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

       }
    

    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}
