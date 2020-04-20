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
class chatMenuVC: UITableViewController {

    var timer: Timer?
    @IBOutlet weak var updateButton: UIButton!

    var chatrooms = [RoomCell]()
    var header = "Chat Menu"
    var db : Firestore?
    
    var docRef : DocumentReference!
   
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        self.loadData(d: db)

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
        return chatrooms.count
    }
    


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = chatrooms[indexPath.row].roomName
        cell.detailTextLabel!.text = chatrooms[indexPath.row].lastMessage
        return cell
    }
    
   
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return self.header
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let user = Auth.auth().currentUser{
            let myUid = user.uid
            
            
            var myself = 0
            var other = 1
            var user = [ATCUser]()
            let cell = self.chatrooms[indexPath.row]
            

            if cell.participants[1].uid == myUid{
                myself = 1
                other = 0
            }
            user.append(ATCUser(uid: cell.participants[other].uid, firstName: cell.participants[other].fName, lastName: cell.participants[other].lName))
            let uiConfig = ATCChatUIConfiguration(uiConfig: ChatUIConfiguration())
            let channel = ATCChatChannel(id: cell.roomid, name: cell.roomName)
            let viewer = ATCUser(uid: cell.participants[myself].uid, firstName: cell.participants[myself].fName, lastName: cell.participants[myself].lName)

            let chatVC = ATCChatThreadViewController(user: viewer,
            channel: channel,
            uiConfig: uiConfig,
            reportingManager: ATCFirebaseUserReporter(),
            chatServiceConfig: ChatServiceConfig(),
            recipients: user)
            self.navigationController?.pushViewController(chatVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        


    }
    
    
    func loadData(d: Firestore){


        self.chatrooms = [RoomCell]()
        d.collection("chatroom").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {

            for document in querySnapshot!.documents {
                var userL = [UserCell]()
                
                if let user = Auth.auth().currentUser{
                    let uid = user.uid
                    
                    d.collection("chatroom").document(document.documentID).collection("users").getDocuments(){(querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        }else{
                            for document in querySnapshot!.documents{
                                if let fname = document.get("fName") as? String{
                                    if let lname = document.get("lName") as? String{
                                        if let uid = document.get("uid") as? String{
                                            userL.append(UserCell(fName: fname, lName: lname, uid: uid))
                                        }
                                    }
                                }
                            }
                            
                            for x in userL{
                                if x.uid == uid{

                                    
                                   d.collection("channels").document(document.documentID).getDocument{(doc, error) in
                                        if let doc = doc, doc.exists{
                                            if let lMsg = doc.get("lastMessage") as? String{
                                                if let date = doc.get("lastMessageDate") as? Timestamp{
                                                    self.chatrooms.append(RoomCell(roomid: document.documentID,roomName:document.get("name") as! String, participants: userL, lastMessage: lMsg, lastDate: date.dateValue()))
                                                    self.tableView.reloadData()
                                                }
                                                
                                            }
                                            
                                        }else{
                                            self.chatrooms.append(RoomCell(roomid: document.documentID,roomName:document.get("name") as! String, participants: userL, lastMessage: "Click here to start a chat", lastDate: Date()))
                                            self.tableView.reloadData()
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }

                }
                
            }
            
            
        }
        }


     
    }
    
    func reloadData(d: Firestore){

        d.collection("chatroom").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var new = true
                    for x in self.chatrooms{
                        if document.documentID == x.roomid{
                            d.collection("channels").document(document.documentID).getDocument{(doc, error) in
                                if let doc = doc, doc.exists{
                                    if let lMsg = doc.get("lastMessage") as? String{
                                        if let date = doc.get("lastMessageDate") as? Timestamp{
                                            x.setLastMessage(str: lMsg)
                                            x.setLastDate(d: date.dateValue())
                                            self.chatrooms = self.chatrooms.sorted(by: {
                                                $0.lastDate.compare($1.lastDate) == .orderedDescending
                                            })
                                            self.tableView.reloadData()
                                        }

                                    }
                                    
                                }
                            }
                            new = false
                            break
                        }
                    }
                    
                    if(new){
                        var userL = [UserCell]()
                        
                        if let user = Auth.auth().currentUser{
                            let uid = user.uid
                            
                            d.collection("chatroom").document(document.documentID).collection("users").getDocuments(){(querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                }else{
                                    for document in querySnapshot!.documents{
                                        if let fname = document.get("fName") as? String{
                                            if let lname = document.get("lName") as? String{
                                                if let uid = document.get("uid") as? String{
                                                    userL.append(UserCell(fName: fname, lName: lname, uid: uid))
                                                }
                                            }
                                        }
                                    }
                                    
                                    for x in userL{
                                        if x.uid == uid{

                                            
                                            d.collection("channels").document(document.documentID).getDocument{(doc, error) in
                                                if let doc = doc, doc.exists{
                                                    if let lMsg = doc.get("lastMessage") as? String{
                                                        if let date = doc.get("lastMessageDate") as? Timestamp{
                                                            self.chatrooms.append(RoomCell(roomid: document.documentID,roomName:document.get("name") as! String, participants: userL, lastMessage: lMsg, lastDate: date.dateValue()))
                                                            self.chatrooms = self.chatrooms.sorted(by: {
                                                                $0.lastDate.compare($1.lastDate) == .orderedDescending
                                                            })
                                                            self.tableView.reloadData()
                                                        }
                                                        
                                                    }
                                                    
                                                }else{
                                                    self.chatrooms.append(RoomCell(roomid: document.documentID,roomName:document.get("name") as! String, participants: userL, lastMessage: "Click here to start a chat", lastDate: Date()))
                                                    self.chatrooms = self.chatrooms.sorted(by: {
                                                        $0.lastDate.compare($1.lastDate) == .orderedDescending
                                                    })
                                                    self.tableView.reloadData()
                                                }
                                            }
                                            
                                            
                                        }
                                    }
                                }
                                
                            }

                        }
                        
                    }
                }
            }
            
        }
        
     
    }
    
    /*
        for x in self.chatrooms{
        print(x.roomid)
        d.collection("channels").document(x.roomid).getDocument{(document, error) in
            if let document = document, document.exists {
                
                if let roomName = document.get("name") as? String {
                    if let lMsg = document.get("lastMessage") as? String{
                        if let lDate = document.get("lastMessageDate") as? Timestamp{
                            self.content.append(ThreadCell(name: roomName,lastMessage: lMsg,lastDate: lDate.dateValue()))
                            self.content = self.content.sorted(by: {
                                $0.lastDate.compare($1.lastDate) == .orderedDescending
                            })
                            
                            
                        }
                    }
                    
                }
                
            } else {
                print("Document does not exist")
            }
            
            
        }

    }*/

    
    override func viewDidAppear(_ animated: Bool) {

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.reloadData(d: Firestore.firestore())
        }
        super.viewWillAppear(true)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        timer?.invalidate()
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
        if segue.identifier == "segUpdate"{
            if let button = sender as! UIButton?{
                if button == updateButton{
                    let updateVC = segue.destination as! UpdateLinkVC
                    updateVC.type = self.t
                    
                }
            }
        }
        
        
    }
  */

}
