//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//
import Firebase
import Foundation
import UIKit



class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 187/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 187/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[-_.,$@$#!%*?&])[A-Za-z\\d-_.,$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isGoodUrl(urlString: String?)-> Bool {
        if let urlString = urlString{
            if NSData(contentsOf: NSURL(string : urlString)! as URL) != nil{
                return true
            }else{
                let check = "http://\(urlString)"
                if NSData(contentsOf: NSURL(string : check)! as URL) != nil{
                    return true;
                }else{
                    let check2 = "https://\(urlString)"
                    if NSData(contentsOf: NSURL(string : check2)! as URL) != nil{
                        return true;
                    }
                }
            }
        }
        return false
    }
    
    static func getGoodUrl(urlString: String?)-> String? {
        let null = ""
        if let urlString = urlString{
            if NSData(contentsOf: NSURL(string : urlString)! as URL) != nil{
                return urlString
            }else{
                let check = "http://\(urlString)"
                if NSData(contentsOf: NSURL(string : check)! as URL) != nil{
                    return check;
                }else{
                    let check2 = "https://\(urlString)"
                    if NSData(contentsOf: NSURL(string : check2)! as URL) != nil{
                        return check2;
                    }
                }
            }
           
        }
        return null
    }
  
    

}
