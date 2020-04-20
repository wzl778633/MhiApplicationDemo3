//
//  FaviconTableViewCell.swift
//  CustomLoginDemo
//
//  Created by Tom Wang on 4/20/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit

class FaviconTableViewCell: UITableViewCell {
    
    var url:URL?{
        didSet{
            
            
            let request = URLRequest(url:self.url! as URL)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: {(data,response,err) -> Void in
                if let data = NSData(contentsOf: self.url!) {
                    let image = UIImage(data: data as Data)
                    OperationQueue.main.addOperation({
                    () -> Void in
                    self.imageView?.image = image
                    self.setNeedsLayout()
                })
            
                }
                
            
               
            }) as URLSessionTask
            dataTask.resume()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
