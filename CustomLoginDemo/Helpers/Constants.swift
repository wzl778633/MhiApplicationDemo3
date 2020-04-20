//
//  Constants.swift
//  CustomLoginDemo
//
//  Created by wang songtao on 2/28/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import Foundation

struct Constants {
    struct Storyboard{
        static let homeViewController = "MenuVC"
        static let viewController = "VC"
    }
    
}
struct BasicCell {
    var desc : String
    var title : String
    var date : Date
    var link : String
}
struct MeetingCell {
    var title : String
    var date : Date
    var link : String
}
struct UserCell:Equatable {
    var fName : String
    var lName : String
    var uid : String
}

class RoomCell {
    var roomid : String
    var roomName : String
    var participants : [UserCell]
    var lastMessage : String
    var lastDate : Date
    init(roomid: String, roomName: String, participants: [UserCell], lastMessage: String, lastDate: Date){
        self.roomid = roomid
        self.roomName = roomName
        self.participants = participants
        self.lastMessage = lastMessage
        self.lastDate = lastDate
    }
    
    func setLastMessage(str: String){
        lastMessage = str
    }
    func setLastDate(d: Date){
        lastDate = d
    }
}
struct ThreadCell:Equatable {
    var name : String
    var lastMessage : String
    
    
    
}

