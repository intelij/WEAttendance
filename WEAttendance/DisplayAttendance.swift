//
//  DisplayAttendance.swift
//  WEAttendance
//
//  Created by shan on 11/1/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit


class DisplayAttendance: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numrecord : Int = 0
    var today = Date()
    var tableView = UITableView()
    var weekdayAll = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ClassLabel: UILabel!
    var attendinfo = [String]()
    
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
         ClassLabel.text =   "For " + classchoose + classdisID
        displayinterval()
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x:37,y:210,width:300,height:380), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numrecord;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellID)
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            cell.textLabel?.text = self.attendinfo[indexPath.row]
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func previousbutton(_ sender: UIButton) {
        self.attendinfo.removeAll()
        today = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        let weekdaypre: String  = weekdayFormatter.string(from: today)
        for i in 0...weekdayAll.count - 1{
            if(weekdayAll[i] == weekdaypre){
                let weekstart = Calendar.current.date(byAdding: .day, value: -i, to: today)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let weekdatestart: String  = dateFormatter.string(from: weekstart)
                let weekend = Calendar.current.date(byAdding: .day, value: +6, to: weekstart)!
                let dateendFormatter = DateFormatter()
                dateendFormatter.dateFormat = "yyyy-MM-dd"
                let weekdateend: String  = dateendFormatter.string(from: weekend)
                DateLabel.text = weekdatestart+"-"+weekdateend
                let gNetID = UserDefaults.standard.value(forKey: "NetID") as? String
                let requestData: String = gNetID!+"&sectionId="+classdisID
                let Timeinterval: String = "&startDate="+weekdatestart+"&endDate="+weekdateend
                let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/checkAttendance.php?netId="+requestData+Timeinterval
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
                            //print(jo)
                        }
                        catch {
                            return   print("error trying to convert data to JSON")
                        }
                        let attendstatus = jo["history"] as! NSArray
                        print(attendstatus.count)
                        self.numrecord = attendstatus.count
                        if (self.numrecord != 0){
                            for n in 0...self.numrecord-1
                        {
                            let attendlist = attendstatus[n] as! NSDictionary
                            let attendstatus = attendlist["attend"] as! String
                            let attenddate = attendlist["date"] as! String
                            if (attendstatus == "1"){
                                self.attendinfo.append(attenddate+"   " + " Attend")
                            }
                            else if (attendstatus == "0"){
                                self.attendinfo.append(attenddate+"   " + " Absent")
                            }
                        }
                        }else{
                            self.attendinfo.append("No attendance for this week.")
                        }
                        //print(attendstatus)
                        print(self.attendinfo)
                        
                    }
                    else{
                        print("error calling GET on /posts/1")
                        print("error")
                    }
                    // print("666",self.myVar)
                })
                // Return value of returnedUserID
                //print("777",self.myVar)
                task.resume()
                self.tableView.reloadData()
                //print("888",self.myVar)
                
            }
    }
    }
    
    @IBAction func nextbutton(_ sender: UIButton) {
        self.attendinfo.removeAll()
        today = Calendar.current.date(byAdding: .day, value: +7, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        let weekdaynex: String  = weekdayFormatter.string(from: today)
        for i in 0...weekdayAll.count - 1{
            if(weekdayAll[i] == weekdaynex){
                let weekstart = Calendar.current.date(byAdding: .day, value: -i, to: today)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let weekdatestart: String  = dateFormatter.string(from: weekstart)
                let weekend = Calendar.current.date(byAdding: .day, value: +6, to: weekstart)!
                let dateendFormatter = DateFormatter()
                dateendFormatter.dateFormat = "yyyy-MM-dd"
                let weekdateend: String  = dateendFormatter.string(from: weekend)
                DateLabel.text = weekdatestart+"-"+weekdateend
                let gNetID = UserDefaults.standard.value(forKey: "NetID") as? String
                let requestData: String = gNetID!+"&sectionId="+classdisID
                let Timeinterval: String = "&startDate="+weekdatestart+"&endDate="+weekdateend
                let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/checkAttendance.php?netId="+requestData+Timeinterval
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
                        }
                        catch {
                            return   print("error trying to convert data to JSON")
                        }
                        let attendstatus = jo["history"] as! NSArray
                        print(attendstatus.count)
                        self.numrecord = attendstatus.count
                        if (self.numrecord != 0){
                            for n in 0...self.numrecord-1
                            {
                                let attendlist = attendstatus[n] as! NSDictionary
                                let attendstatus = attendlist["attend"] as! String
                                let attenddate = attendlist["date"] as! String
                                if (attendstatus == "1"){
                                    self.attendinfo.append(attenddate+"   " + " Attend")
                                }
                                else if (attendstatus == "0"){
                                    self.attendinfo.append(attenddate+"   " + " Absent")
                                }
                            }
                        }else{
                            self.attendinfo.append("No attendance for this week.")
                        }
                        //print(attendstatus)
                        print(self.attendinfo)
                        
                    }
                    else{
                        print("error calling GET on /posts/1")
                        print("error")
                    }
                    // print("666",self.myVar)
                })
                // Return value of returnedUserID
                //print("777",self.myVar)
                task.resume()
                self.tableView.reloadData()
                //print("888",self.myVar)
            
            }
        }
    }
    
    func displayinterval(){
//        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todaydate: String  = dateFormatter.string(from: today)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        let weekday: String  = dateFormatter1.string(from: today)
        
        for i in 0...weekdayAll.count - 1{
            if(weekdayAll[i] == weekday){
                let Weekstart = Calendar.current.date(byAdding: .day, value: -i, to: today)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let weekdate: String  = dateFormatter.string(from: Weekstart)
                DateLabel.text = weekdate+" ~ "+todaydate
                let gNetID = UserDefaults.standard.value(forKey: "NetID") as? String
                let requestData: String = gNetID!+"&sectionId="+classdisID
                let Timeinterval: String = "&startDate="+weekdate+"&endDate="+todaydate
        
                let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/checkAttendance.php?netId="+requestData+Timeinterval
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
            
                            //print(jo)
                        }
                        catch {
                            return   print("error trying to convert data to JSON")
                        }
                        let attendstatus = jo["history"] as! NSArray
                        print(attendstatus.count)
                        self.numrecord = attendstatus.count
                        if (self.numrecord != 0){
                            for n in 0...self.numrecord-1
                            {
                                let attendlist = attendstatus[n] as! NSDictionary
                                let attendstatus = attendlist["attend"] as! String
                                let attenddate = attendlist["date"] as! String
                                if (attendstatus == "1"){
                                self.attendinfo.append(attenddate+"   " + " Attend")
                                }
                                else if (attendstatus == "0"){
                                    self.attendinfo.append(attenddate+"   " + " Absent")
                                }
                            }
                        }else{
                            self.attendinfo.append("No attendance for this week.")
                        }
                        //print(attendstatus)
                        print(self.attendinfo)
                    }
                    else{
                        print("error calling GET on /posts/1")
                        print("error")
                    }
                })
                task.resume()
            }
        }
        }
    
}

