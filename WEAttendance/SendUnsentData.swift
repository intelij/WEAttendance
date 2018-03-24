//
//  SendUnsentData.swift
//  iAttendance
//
//  Created by Prasidha 2/24/18
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class SendUnsentData: UIViewController {
    
    var newReports: [EventReportFails] = []
    @IBAction func sendData(_ sender: UIButton) {
        let AD = AppDelegate()
        
        var reps = AD.getReportFails()
        
        
        
        var arrayOfSuccessfulUpdate = [Int]()
        
        var indexOfSuccessfulUpdate = 0
        print("upload fail num: ", reps.count)
        for (index, item) in reps.enumerated(){
            print("working on index: ", index)
            let netid = item.netId
            let eventTime = item.eventTime
            let eventDate = item.eventDate
            let uuid = item.uuid
            var major = item.major
            major = major.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
            var minor = item.minor
            minor = minor.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
            let status = item.status
            
            print(netid)
            print(eventTime)
            print(eventDate)
            print(uuid)
            print(major)
            print(minor)
            print(status)
            reCheckIn(netid: netid, uuid:uuid, major:major, minor:minor, eventTime:eventTime, eventDate: eventDate, status: status)
        }
        
        AD.setReportFails(reports: newReports)
        
        
    }
    
    //
    //        print(arrayOfSuccessfulUpdate.count)
    //        if(arrayOfSuccessfulUpdate.count != 0){
    //            for(index, item) in arrayOfSuccessfulUpdate.reversed().enumerated(){
    //                print("remove ", index)
    //            }
    //        }
    
    
    
    func reCheckIn(netid: String, uuid:String, major:String, minor:String, eventTime:String, eventDate: String, status: String){
        print("rechecking")
        let postEndpoint: String="https://www.uvm.edu/~weattend/dbConnection/reCheckIn.php?netId=\(netid)&uuid=\(uuid)&major=\(major)&minor=\(minor)&date=\(eventDate)&time=\(eventTime)&status=checkOut"
        print(postEndpoint)
        guard let url = URL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // If data exists, grab it and set it to our global variable
            if (error == nil) {
                let jo : NSDictionary
                do {
                    jo = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    let updateStatus = jo["updateDB"] as! String
                    if(updateStatus != "true"){
                        self.saveReportFail(major: major, minor: minor, status: status, time: eventTime, netid: netid, date: eventDate, uuid: uuid)
                    }
                }
                catch {
                    self.saveReportFail(major: major, minor: minor, status: status, time: eventTime, netid: netid, date: eventDate, uuid: uuid)
                    return print("error trying to convert data to JSON")
                }
            }
            else{
                self.saveReportFail(major: major, minor: minor, status: status, time: eventTime, netid: netid, date: eventDate, uuid: uuid)
                print("error calling GET on /posts/1")
            }
        })
        task.resume()
    }
    
    func saveReportFail(major: String, minor: String, status: String, time: String, netid: String, date: String, uuid: String){
        let report1 = EventReportFails(netId: netid , status: status , eventTime: time , eventDate: date , uuid: uuid , major: major , minor: minor)
        newReports.append(report1)
    }
    
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        super.viewDidLoad()
        
        
    }
    
}

