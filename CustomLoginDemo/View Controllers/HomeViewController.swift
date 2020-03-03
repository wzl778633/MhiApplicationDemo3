//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by wang songtao on 2/28/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var ContactsButton: UIButton!
       @IBOutlet weak var JobsButton: UIButton!
       @IBOutlet weak var LinksButton: UIButton!
       @IBOutlet weak var MiscButton: UIButton!
       
       @IBAction func ContactButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)

       }
       @IBAction func JobButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)
       }
       @IBAction func LinkButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)
       }
       @IBAction func MiscButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)
       }
       
       
       override func viewDidLoad() {
           super.viewDidLoad()

           
           // Do any additional setup after loading the view.
           


       }
       
    @IBAction func signOutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        let vc : ViewController = self.storyboard?.instantiateViewController(withIdentifier: "VC") as! ViewController
        let navigationController = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController,animated: true,completion: nil)

        
        

    }
    
       
       // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           if segue.identifier == "segShowTable"{
               if let button = sender as! UIButton?{
                   if button == ContactsButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.t = "Contacts"
                   }else if button == JobsButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.t = "Jobs"
                   }else if button == LinksButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.t = "Links"
                   }else if button == MiscButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.t = "Misc"
                   }
               }
           }
       }
}
