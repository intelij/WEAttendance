//
//  MonitoringRegion.swift
//  WEAttendance
//
//  Created by Neal Zhu on 11/6/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import Foundation


class MonitoringRegion: NSObject, NSCoding {
    
    var subject: String
    var courseNum: String
    var section: String
    var buildingArea: String
    var room: String
    var uuid: String
    var major: String
    var minor: String
    
    init(subject: String, courseNum: String, section: String, buildingArea: String, room: String, uuid: String, major: String, minor: String){
        self.subject = subject
        self.courseNum = courseNum
        self.section = section
        self.buildingArea = buildingArea
        self.room = room
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.subject = (aDecoder.decodeObject(forKey: "subject") as? String)!
        self.courseNum = (aDecoder.decodeObject(forKey: "courseNum") as? String)!
        self.section = (aDecoder.decodeObject(forKey: "section") as? String)!
        self.buildingArea = (aDecoder.decodeObject(forKey: "buildingArea") as? String)!
        self.room = (aDecoder.decodeObject(forKey: "room") as? String)!
        self.uuid = (aDecoder.decodeObject(forKey: "uuid") as? String)!
        self.major = (aDecoder.decodeObject(forKey: "major") as? String)!
        self.minor = (aDecoder.decodeObject(forKey: "minor") as? String)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(subject, forKey: "subject")
        aCoder.encode(courseNum, forKey: "courseNum")
        aCoder.encode(section, forKey: "section")
        aCoder.encode(buildingArea, forKey: "buildingArea")
        aCoder.encode(room, forKey: "room")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(major, forKey: "major")
        aCoder.encode(minor, forKey: "minor")
    }
}
