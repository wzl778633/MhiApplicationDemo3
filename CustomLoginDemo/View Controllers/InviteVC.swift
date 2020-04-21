//
//  AboutVC.swift
//  demo1
//
//  Created by Dongqi Yin on 2/12/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class user: UITableViewCell{
    
    @IBOutlet var userLabel: UILabel!
    var information = UserCell(fName: "",lName: "", uid: "")
}
class InviteVC: UITableViewController {


    var content = [UserCell]()
    var selectedUser = [UserCell]()
    var header = "Please select invitees"
    var t = "users"
    var db : Firestore?
    var type: String = ""
    
    var docRef : DocumentReference!
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.type == "meeting"){
            self.tableView.allowsMultipleSelection = true
        }else if((self.type == "chat")){
            self.tableView.allowsMultipleSelection = false
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      
    }

    
    // MARK: - Table view data source
    
    func getPeople() -> [UserCell]{
        return self.selectedUser
    }

    @IBAction func performUpdate(_ sender: UIButton) {
        performSegue(withIdentifier: "segUpdate", sender: sender)
    }
    @IBAction func performInvite(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

        if self.navigationController?.topViewController is UpdateMeetingVC{
            let vc = self.navigationController?.topViewController as! UpdateMeetingVC
            vc.updateInvite(invitees: selectedUser)
        }else if self.navigationController?.topViewController is NewChatVC{
            let vc = self.navigationController?.topViewController as! NewChatVC
            vc.updateInvite(invitees: selectedUser)
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return content.count
    }
    


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! user

        cell.information = content[indexPath.row]
        cell.userLabel!.text = content[indexPath.row].fName + " " + content[indexPath.row].lName
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return self.header
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedUser.append(self.content[indexPath.row])

    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        if let idx = selectedUser.firstIndex(of: self.content[indexPath.row]){
            selectedUser.remove(at: idx)
        }

        
    }
    
    
    func loadData(Type: String, d: Firestore){
        d.collection(Type).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.content = [UserCell]()
            for document in querySnapshot!.documents {
               

                if let fname = document.get("firstName") as? String {
                    if let lname = document.get("lastName") as? String{
                        if let uid = document.get("userID") as? String{
                            
                            let yourself = Auth.auth().currentUser?.uid
                            if uid != yourself{
                                self.content.append(UserCell(fName: fname,lName: lname,uid: uid))
                            }else{
                                self.selectedUser.append(UserCell(fName: fname,lName: lname,uid: uid))
                            }

                            
                            
                        }
                    }
                    
                }
            }
           
                         
            self.tableView.reloadData()
            
        }
    }
    }

    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        self.loadData(Type: self.t, d: db)
        super.viewWillAppear(true)
        
        
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destiBroller.

        
        
    }
    
*/
}
