//
//  ClassStatus.swift
//  iAttendance
//
//  Created by shan on 10/22/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit
import CoreLocation

var classnums = [String]()
var classsec = [String]()
var classdis = [String]()
var classID = [String]()
var Numclassnow : Int = 0


class ClassStatus: UIViewController, CLLocationManagerDelegate, ESTBeaconManagerDelegate {
    
    var window: UIWindow?
    let beaconManager = ESTBeaconManager()

    @IBOutlet weak var beaconStatus: UIImageView!
    
    @IBOutlet weak var beaconStatusLabel: UILabel!
    
    let locationManager = CLLocationManager()
//    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")


    
    //for each class
    //loop though identifiers
    
    override func viewDidLoad() {
        //            classsec.removeAll()
        //            classdis.removeAll()
        //            classnums.removeAll()
        if (classdis.count == 0){
            login(NetID)
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            
            
            var beaconMajor:String = " "

            let regions = getRegionsArray()
            var end = 0
            //make sure no more than 20 regions is moniotred
            if(regions.count < 20 && regions.count > 0){
                end = regions.count-1
            }else if(regions.count >= 20){
                end = 19
            }
            if(end != 0){
                for i in 0...end{
                    
                    print("monitoring uuid: \(regions[i].uuid), major: \(regions[i].major), minor: \(regions[i].minor)")
                    self.beaconManager.startMonitoring(for: CLBeaconRegion(
                        proximityUUID: UUID(uuidString: regions[i].uuid)!,
                        major: UInt16(regions[i].major)!, minor: UInt16(regions[i].minor)!, identifier: ""))
                    //for loop going though all the majors
                    beaconMajor = regions[i].major;
                    if(regions[i].major == "1234"){
                        //link to get the class name?
                        //maybe its saved?
                        beaconStatusLabel.text = "You are in  .... " //+ the class name
                        
                    }
                    
                }
            }
//            beaconStatusLabel.text = "You are in classroom with major" + beaconMajor;
            beaconStatusLabel.text = "You're within range of a class / event!"

            beaconStatus.image = UIImage (named: "checkMark.png")
        } else {
            beaconStatusLabel.text = "You are out of range of a class / event"
            beaconStatus.image = UIImage (named: "xMark.png")
            
        }
    }
    
 
    
    // return current monitoring region. if the region is not set, return empty array
    func getRegionsArray() -> Array<MonitoringRegion>{
        var regions: [MonitoringRegion] = []
        if(UserDefaults.standard.object(forKey: "monitorRegions") != nil){
            let RegionsData = UserDefaults.standard.object(forKey: "monitorRegions") as? NSData
            if(NSKeyedUnarchiver.unarchiveObject(with: RegionsData! as Data) != nil){
                regions = (NSKeyedUnarchiver.unarchiveObject(with: RegionsData! as Data) as? [MonitoringRegion])!
            }else{
                let regionsData = NSKeyedArchiver.archivedData(withRootObject: regions)
                UserDefaults.standard.set(regionsData, forKey: "monitorRegions")
            }
        }else{
            let regionsData = NSKeyedArchiver.archivedData(withRootObject: regions)
            UserDefaults.standard.set(regionsData, forKey: "monitorRegions")
        }
        return regions
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
                        let courseS = clas["courseSubj"] as! String
                        let courseN = clas["courseNum"] as! String
                        let courseE = clas["section"] as! String
                        let courseB = clas["sectionId"] as! String
                        //                        self.classnums.append(CourseS+" "+CourseN)
                        classsec.append("Section "+courseE)
                        if (courseN.count==1){
                            classnums.append(courseS+" "+"00"+courseN)
                            classdis.append(courseS+" "+"00"+courseN+" "+"Section "+courseE)
                            classID.append(courseB)
                        }
                        else if (courseN.count==2){
                            classnums.append(courseS+" "+"0"+courseN)
                            classdis.append(courseS+" "+"0"+courseN+" "+"Section "+courseE)
                            classID.append(courseB)
                        }
                        else{
                            classnums.append(courseS+" "+courseN)
                            classdis.append(courseS+" "+courseN+" "+"Section "+courseE)
                            classID.append(courseB)
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

