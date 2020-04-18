//
//  TestVC.swift
//  CustomLoginDemo
//
//  Created by Tom Wang on 4/18/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var user = [ATCUser]()
        user.append(ATCUser(uid: "OUccAftTthfJxwHwf6yxI2htyOJ2", firstName: "Florian", lastName: "Marcu"))
        let uiConfig = ATCChatUIConfiguration(uiConfig: ChatUIConfiguration())
        let channel = ATCChatChannel(id: "channel_id", name: "Chat Title")
        let viewer = ATCUser(uid: "OUccAftTthfJxwHwf6yxI2htyOJ2",firstName: "Florian", lastName: "Marcu")
        let chatVC = ATCChatThreadViewController(user: viewer,
        channel: channel,
        uiConfig: uiConfig,
        reportingManager: ATCFirebaseUserReporter(),
        chatServiceConfig: ChatServiceConfig(),
        recipients: user)
        self.present(chatVC, animated: true, completion: nil)
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
