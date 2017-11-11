//
//  DisplayAttendance.swift
//  WEAttendance
//
//  Created by shan on 11/1/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class DisplayAttendance: UIViewController {
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ClassLabel: UILabel!
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
         ClassLabel.text =   "For " + classchoose + classdisID
        displayinterval()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func displayinterval(){
        let today = Date()
//        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todaydate: String  = dateFormatter.string(from: today)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        let weekday: String  = dateFormatter1.string(from: today)
        
        
        
        let weekdayAll = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
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
                            print(jo)
                        }
                        catch {
                            return   print("error trying to convert data to JSON")
                        }
                        
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
                //print("888",self.myVar)
            }
        }

        }
    }



