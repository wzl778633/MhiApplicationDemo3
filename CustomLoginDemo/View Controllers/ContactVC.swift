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
class ContactVC: UITableViewController {

    @IBOutlet weak var updateButton: UIButton!
    var content = [MeetingCell]()
    var header = "Meeting"
    var t = "Meeting"
    var db : Firestore?
    
    var docRef : DocumentReference!
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      
                      
        
        
        
    }

    // MARK: - Table view data source

    @IBAction func performUpdate(_ sender: UIButton) {
        performSegue(withIdentifier: "segUpdate", sender: sender)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        
        // Configure the cell...
        cell.textLabel!.text = content[indexPath.row].title
        cell.detailTextLabel!.text = content[indexPath.row].date.description
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doc = self.content[indexPath.row].title

        let exit = UIContextualAction(style: .destructive, title: "Exit"){  (contextualAction, view, boolValue) in
            let alertController = UIAlertController(title: "Exit this meeting?", message: "Are you really want to exit this meeting?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Say Goodbay", style: .destructive, handler: {(alertAction) in
                    self.exitDoc(title: doc)
            }))
           
            self.present(alertController,animated: true,completion: nil)
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete"){  (contextualAction, view, boolValue) in
                   let alertController = UIAlertController(title: "Delete this meeting?", message: "Are you really want to Delete this meeting?", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                   alertController.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: {(alertAction) in
                           self.deleteDoc(title: doc)
                   }))
                  
                   self.present(alertController,animated: true,completion: nil)
                   
               }
       
        
        let open = UIContextualAction(style: .normal, title: "Join") {  (contextualAction, view, boolValue) in
            let url = Utilities.getGoodUrl(urlString: self.content[indexPath.row].link)
            if let url = NSURL(string: url!){
                           UIApplication.shared.openURL(url as URL)
                       }
        }
        
        delete.backgroundColor = UIColor.red
        exit.backgroundColor = UIColor.orange
        open.backgroundColor = UIColor.init(red: 0/255, green: 200/255, blue: 0/255, alpha: 1)
        let swipeActions = UISwipeActionsConfiguration(actions: [exit,delete,open])
        return swipeActions
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return self.header
    }
    
    func loadData(Type: String, d: Firestore){
        d.collection(Type).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.content = [MeetingCell]()
            for document in querySnapshot!.documents {
                let user = Auth.auth().currentUser
               if let user = user {
                    
                    let uid = user.uid
                
                d.collection(Type).document(document.documentID).collection("participants").whereField("UID", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                        if let err = err{
                            print("No such user: \(err)")
                        }else{
                            if (querySnapshot?.documents.count)! > 0{
                                if let tmp = document.get("time") as? Timestamp {
                                    let currentTime = Timestamp.init()
                                    if  (Timestamp(date:tmp.dateValue().addingTimeInterval(86400))).compare(currentTime) == ComparisonResult.orderedAscending{
                                        if let desc = document.get("Zoom") as? String{
                                        self.content.append(MeetingCell(title: document.documentID + " (expired)", date: tmp.dateValue(), link: desc))
                                        }
                                    }else{
                                    if let desc = document.get("Zoom") as? String{
                                        self.content.append(MeetingCell(title: document.documentID, date: tmp.dateValue(), link: desc))
                                        }
                                    
                                    }
                                               
                                }
                            }
                             
                            
                        }
                        self.tableView.reloadData()
                    }
                
               
                }
            }
           
            
            
        }
    }
     
    }
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        self.loadData(Type: "Meeting", d: db)
        super.viewWillAppear(true)
        
        
    }
    
    
    func exitDoc(title : String){
        let d = Firestore.firestore()
        let user = Auth.auth().currentUser
             if let user = user {
             let email = user.email
            d.collection(self.t).document(title).collection("participants").whereField("Email", isEqualTo: email!).getDocuments(){(querySnapshot, err) in
            if let err = err{
             print("Error happened: \(err)")
            }else{
                 for document2 in querySnapshot!.documents {                    d.collection(self.t).document(title).collection("participants").document(document2.documentID).delete()
                }
        }
            self.loadData(Type: self.t, d: d)
                
            
        
    }
        }
    }

    
    func deleteDoc(title : String){
        let d = Firestore.firestore()
        //d.collection(self.t).document(title).collection("participants").d
        d.collection(self.t).document(title).delete()
        self.loadData(Type: self.t, d: d)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destiBroller.
        if segue.identifier == "segUpdate"{
            if let button = sender as! UIButton?{
                if button == updateButton{
                    let updateVC = segue.destination as! UpdateLinkVC
                    updateVC.type = self.t
                    
                }
            }
        }
        
        
    }
    

}
