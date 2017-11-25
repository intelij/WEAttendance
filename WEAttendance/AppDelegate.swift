//
//  AppDelegate.swift
//  WEAttendance
//
//  Created by Prasidha Timsina on 10/26/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {
    
    var window: UIWindow?
    let beaconManager = ESTBeaconManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // set up beacon manager
        ESTConfig.setupAppID("weattendance-2lq", andAppToken: "a65fb0eb6418d444bc866aa8b5d44e15")
        
        self.beaconManager.delegate = self
        
        self.beaconManager.requestAlwaysAuthorization()
        
        // ask the user to allow notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("notifications allowed? = \(granted)")
        }
        
        //ask user to allow location
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        
        var vc: UIViewController
        
        if(UserDefaults.standard.value(forKey: "NetID") as? String) == nil{
            
            vc = storyboard.instantiateViewController(withIdentifier: "LoginID")
            
        }else{
            
            vc = storyboard.instantiateInitialViewController()!
            // set up the monitor regions
            getRegion(netId: (UserDefaults.standard.value(forKey: "NetID") as! String))
        }
        
        self.window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()
        
        // Example code,
        //        self.beaconManager.startMonitoring(for: CLBeaconRegion(
        //            proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        //            major: 45268, identifier: ""))
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
               // UIApplication.sharedApplication().openURL()

                let settings: String = UIApplicationOpenSettingsURLString
                let settingsURL = URL(string: settings)
                UIApplication.shared.openURL(settingsURL!)
                
                //openURL:options:completionHandler:
                
            case .authorizedAlways:
                print("Access")
            case .authorizedWhenInUse:
                print("when in use")
                self.beaconManager.requestAlwaysAuthorization()
            }
        } else {
            print("Location services are not enabled")
        }
        
        return true
    }

    
//    func showEventsAcessDeniedAlert() {
//        let alertController = UIAlertController(title: "Sad Face Emoji!",
//                                                message: "The calendar permission was not authorized. Please enable it in Settings to continue.",
//                                                preferredStyle: .alert)
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
//            // THIS IS WHERE THE MAGIC HAPPENS!!!!
//            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
//                UIApplication.shared.openURL(appSettings as URL)
//            }
//        }
//        alertController.addAction(settingsAction)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        presentViewController(alertController, animated: true, completion: nil)
//    }
    
    // find all the regions in the userdefult, monitor the first 20 of them
    func startMonitorRegions(){
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
            }
        }
    }
    
    // set given an array of monitoringRegion to UserDefaults where key is "monitorRegions"
    func setRegion(regions: [MonitoringRegion]) {
        print("setregion")
        let regionsData = NSKeyedArchiver.archivedData(withRootObject: regions)
        UserDefaults.standard.set(regionsData, forKey: "monitorRegions")
    }
    
    // get all the class location and corespond region uuid, major and minor
    func getRegion(netId: String) {
        
        let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/getClassMonitorRegions.php?netId=" + netId
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
                    let regions = jo["regions"] as! NSArray
                    var regionsArray = [MonitoringRegion]()
                    let regionsNum = regions.count
                    for n in 0...regionsNum-1{
                        let region = regions[n] as! NSDictionary
                        let region1 = MonitoringRegion(subject: (region["subject"] as! String), courseNum: region["courseNum"] as! String, section: region["section"] as! String, buildingArea: (region["buildingArea"] as! String), room: region["room"] as! String, uuid: region["uuid"] as! String, major: region["major"] as! String, minor: region["minor"] as! String)
                        regionsArray.append(region1)
                    }
                    self.setRegion(regions: regionsArray)
                    self.loadRegions()
                    self.startMonitorRegions()
                }
                catch {
                    return print("error trying to convert data to JSON")
                }
            }
            else{
                print("error calling GET on /posts/1")
                print(error)
            }
        })
        task.resume()
    }
    
    // print out current monitoring region
    func loadRegions() {
        guard let RegionsData = UserDefaults.standard.object(forKey: "monitorRegions") as? NSData else {
            print("'monitorRegions' not found in UserDefaults")
            return
        }
        guard let regions = NSKeyedUnarchiver.unarchiveObject(with: RegionsData as Data) as? [MonitoringRegion] else {
            print("Could not unarchive from RegionsData")
            return
        }
        
        for region in regions {
            print("")
            print("courseNum: \(region.courseNum)")
            print("uuid: \(region.uuid)")
            print("major: \(region.major)")
            print("minor: \(region.minor)")
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
    
    
    
    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(
            identifier: "BeaconNotification", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        
        print("enter")
        let netid = UserDefaults.standard.value(forKey: "NetID") as! String
        let uuid = region.proximityUUID
        let major = region.major as! Int
        let minor = region.minor as! Int
        let identifier = ""
        let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/checkIn.php?netId=\(netid)&uuid=\(uuid)&major=\(major)&minor=\(minor)&identifier=\(identifier)&status=checkIn"
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
                }
                catch {
                    return print("error trying to convert data to JSON")
                }
            }
            else{
                print("error calling GET on /posts/1")
                print(error)
            }
        })
        task.resume()
        showNotification(title: "Hello!", body: "You entered the range of a beacon! \(region.major)")
        
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        let netid = UserDefaults.standard.value(forKey: "NetID") as! String
        let uuid = region.proximityUUID
        let major = region.major as! Int
        let minor = region.minor as! Int
        let identifier = ""
        let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/checkIn.php?netId=\(netid)&uuid=\(uuid)&major=\(major)&minor=\(minor)&identifier=\(identifier)&status=checkOut"
        print("exit")
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
                }
                catch {
                    return print("error trying to convert data to JSON")
                }
            }
            else{
                print("error calling GET on /posts/1")
                print(error)
            }
        })
        task.resume()
        showNotification(title: "GoodBye!", body: "You left the range of a beacon! \(region.major)")
    }
    func beaconManager(_ manager: Any, didDetermineInitialState state: ESTMonitoringState,
                       forBeaconWithIdentifier identifier: String) {
        // state codes: 0 = unknown, 1 = inside, 2 = outside
        print("didDetermineInitialState '\(state)' for beacon \(identifier)")
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

