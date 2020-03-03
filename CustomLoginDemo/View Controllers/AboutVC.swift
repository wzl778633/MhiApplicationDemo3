//
//  AboutVC.swift
//  demo1
//
//  Created by Dongqi Yin on 2/12/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import Firebase

class AboutVC: UITableViewController {

    @IBOutlet weak var updateButton: UIButton!
    var content = [BasicCell]()
    var header : String?
    var t : String?
    var db : Firestore?
    
  
    
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
        cell.detailTextLabel!.text = content[indexPath.row].desc
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doc = self.content[indexPath.row].title

        let delete = UIContextualAction(style: .destructive, title: "Delete"){  (contextualAction, view, boolValue) in
            let alertController = UIAlertController(title: "Delete this link?", message: "Are you really want to delete this link?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(alertAction) in self.deleteDoc(title: doc)
            }))
           
            self.present(alertController,animated: true,completion: nil)
            
        }
        
        let update = UIContextualAction(style: .destructive, title: "Update") {  (contextualAction, view, boolValue) in
            let updateController = UIAlertController(title: "Update this link", message: "Enter the infomation for update", preferredStyle: .alert)
            updateController.addTextField()
            updateController.addTextField()
            
            updateController.textFields![0].placeholder = "Description"
            updateController.textFields![1].placeholder = "Link"
            
            
            updateController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            updateController.addAction(UIAlertAction(title: "Update", style: .destructive, handler: {(alertAction) in
                let des = updateController.textFields![0].text
                let lnk = updateController.textFields![1].text
                if Utilities.isGoodUrl(urlString: lnk) == false{
                    
                    let updateErrorController = UIAlertController(title: "Update Fail", message: "Please enter a vaild link!", preferredStyle: .alert)
                    updateErrorController.addAction(UIAlertAction(title: "I know it's my mistake:(", style: .default, handler: {(alertAction) in
                        self.present(updateController,animated: true,completion: nil)
                    }))
                    self.present(updateErrorController,animated: true,completion: nil)
                }else{
                    self.updateDoc(title: doc, des: des!, link: lnk!)
                }
            }))
            self.present(updateController,animated: true,completion: nil)
            
        }
        
        let open = UIContextualAction(style: .normal, title: "Open") {  (contextualAction, view, boolValue) in
            let url = Utilities.getGoodUrl(urlString: self.content[indexPath.row].link)
            if let url = NSURL(string: url!){
                           UIApplication.shared.openURL(url as URL)
                       }
        }
        
        delete.backgroundColor = UIColor.red
        update.backgroundColor = UIColor.orange
        open.backgroundColor = UIColor.init(red: 0/255, green: 200/255, blue: 0/255, alpha: 1)
        let swipeActions = UISwipeActionsConfiguration(actions: [delete,open,update])
        return swipeActions
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return self.header
    }
    
    func loadData(Type: String, d: Firestore){
        d.collection(Type).order(by: "Date",descending: true).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.content = [BasicCell]()
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")

                if let tmp = document.get("Date") as? Timestamp {
                    if let desc = document.get("Description") as? String{
                        if let lnk = document.get("Link") as? String{
                            self.content.append(BasicCell(desc: desc, title: document.documentID, date: tmp.dateValue(), link: lnk))
                            print(self.content)
                        }
                    }
                    
                }
            }
            self.header = Type
           
                         
            self.tableView.reloadData()
            
        }
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let type = t{
            let db = Firestore.firestore()
            self.loadData(Type: type, d: db)
        }
        super.viewWillAppear(true)
        
    }
    
    
    func deleteDoc(title : String){
            let d = Firestore.firestore()
           d.collection(self.t!).document(title).delete()
            self.loadData(Type: self.t!, d: d)
                
            
        
    }
    
    func updateDoc(title: String, des : String, link:String){
            let d = Firestore.firestore()
        d.collection(self.t!).document(title).updateData(["Description":des, "Link":link,"Date": Timestamp.init()])
            self.loadData(Type: self.t!, d: d)
        
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
