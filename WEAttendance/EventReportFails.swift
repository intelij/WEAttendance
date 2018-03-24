//
//  EventReportFails.swift
//  WEAttendance
//
//  Created by Neal Zhu on 2/25/18.
//  Copyright © 2018 Prasidha Timsina. All rights reserved.
//

import Foundation

class EventReportFails: NSObject, NSCoding {
    
    var netId: String
    var status: String
    var eventTime: String
    var eventDate: String
    var uuid: String
    var major: String
    var minor: String
    
    init(netId: String, status: String, eventTime: String, eventDate: String, uuid: String, major: String, minor: String){
        self.netId = netId
        self.status = status
        self.eventTime = eventTime
        self.eventDate = eventDate
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.netId = (aDecoder.decodeObject(forKey: "netId") as? String)!
        self.status = (aDecoder.decodeObject(forKey: "status") as? String)!
        self.eventTime = (aDecoder.decodeObject(forKey: "eventTime") as? String)!
        self.eventDate = (aDecoder.decodeObject(forKey: "eventDate") as? String)!
        self.uuid = (aDecoder.decodeObject(forKey: "uuid") as? String)!
        self.major = (aDecoder.decodeObject(forKey: "major") as? String)!
        self.minor = (aDecoder.decodeObject(forKey: "minor") as? String)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(netId, forKey: "netId")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(eventTime, forKey: "eventTime")
        aCoder.encode(eventDate, forKey: "eventDate")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(major, forKey: "major")
        aCoder.encode(minor, forKey: "minor")
    }
}
