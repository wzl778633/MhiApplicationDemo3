//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by wang songtao on 2/28/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var AboutButton: UIButton!
       @IBOutlet weak var CourseButton: UIButton!
       @IBOutlet weak var MessageButton: UIButton!
       @IBOutlet weak var ScheduleButton: UIButton!
       
       @IBAction func AboutButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)

       }
       @IBAction func CourseButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)
       }
       @IBAction func MessageButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)
       }
       @IBAction func ScheduleButtonAction(_ sender: Any) {
           performSegue(withIdentifier: "segShowTable", sender: sender)
       }
       
       
       override func viewDidLoad() {
           super.viewDidLoad()

           
           // Do any additional setup after loading the view.
           


       }
       

       
       // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           if segue.identifier == "segShowTable"{
               if let button = sender as! UIButton?{
                   if button == AboutButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.initialize(type: "About")
                   }else if button == CourseButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.initialize(type: "Course")
                   }else if button == MessageButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.initialize(type: "Message")
                   }else if button == ScheduleButton{
                       let tableVC = segue.destination as! AboutVC
                       tableVC.initialize(type: "Schedule")
                   }
               }
           }
       }
}
