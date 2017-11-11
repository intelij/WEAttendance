//
//  ClassStatus.swift
//  iAttendance
//
//  Created by shan on 10/22/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

var classnums = [String]()
var classsec = [String]()
var classdis = [String]()
var classID = [String]()
var Numclassnow : Int = 0


class ClassStatus: UIViewController {

    override func viewDidLoad() {
//            classsec.removeAll()
//            classdis.removeAll()
//            classnums.removeAll()
        if (classdis.count == 0){
            login(NetID)
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func login(_ netid: String) {
        let gNetID = UserDefaults.standard.value(forKey: "NetID") as? String
        let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/getStuInfo.php?netId="+gNetID!
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
                let classlist = jo["classList"] as! NSArray
                //                print(classlist.count)
                //                print(jo)
                Numclassnow = classlist.count
                print(Numclassnow)
                 if (classlist.count != 0){
                for n in 0...Numclassnow-1
                {
                    let clas = classlist[n] as! NSDictionary
                    
                    print(clas["courseNum"]!)
                    let CourseS = clas["courseSubj"] as! String
                    let CourseN = clas["courseNum"] as! String
                    let CourseE = clas["section"] as! String
                    let CourseB = clas["sectionId"] as! String
                    //                        self.classnums.append(CourseS+" "+CourseN)
                    classsec.append("Section "+CourseE)
                    if (CourseN.count==1){
                        classnums.append(CourseS+" "+"00"+CourseN)
                        classdis.append(CourseS+" "+"00"+CourseN+" "+"Section "+CourseE)
                        classID.append(CourseB)
                    }
                    else if (CourseN.count==2){
                        classnums.append(CourseS+" "+"0"+CourseN)
                        classdis.append(CourseS+" "+"0"+CourseN+" "+"Section "+CourseE)
                        classID.append(CourseB)
                    }
                    else{
                        classnums.append(CourseS+" "+CourseN)
                        classdis.append(CourseS+" "+CourseN+" "+"Section "+CourseE)
                        classID.append(CourseB)
                    }     
                    }
                    
                }
//                 }else{
//                    let alertController = UIAlertController(title: "Opps!", message: "You do not have class on your record now. Please contact with registrar office!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
//
//
//                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
//
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                        (result : UIAlertAction) -> Void in
//                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginID")
//                        self.present(newViewController, animated: false, completion: nil)
//                        print("OK")
//                    }
//
//
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion: nil)
//
//                }
                
                print(classnums)
                print(classsec)
                print(classID)
                
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
