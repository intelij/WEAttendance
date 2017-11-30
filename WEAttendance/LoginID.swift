//
//  LoginID.swift
//  iAttendance
//
//  Created by Prasidha Timsina on 10/12/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

var NetID : String = ""
var Lastname : String = ""
var Numclass : Int = 0
var classnumsfirst = [String]()
var classsecfirst = [String]()
var accesscode : Int = 0
var uvmemail : String = ""
var counter = 0.0
var timer = Timer()


class LoginID: UIViewController, UITextFieldDelegate {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var TextInput: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        TextInput.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var myVar : String = ""
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login(TextInput.text!)
        // print(self.myVar)
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
//            {
//                self.decide()
//        })
        return true
    }
    
    
    func login(_ netid: String) {
        
        let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/getStuInfo.php?netId="+netid
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
                let status = jo["isStudent"] as! String
                let classlist = jo["classList"] as! NSArray
                print(classlist.count)
                Numclass = classlist.count
                print(jo)
                if (classlist.count != 0){
                for n in 0...classlist.count-1
                {
                let clas = classlist[n] as! NSDictionary
                print(clas["courseNum"]!)
                let courseS = clas["courseSubj"] as! String
                let courseN = clas["courseNum"] as! String
                if (courseN.count==1){
                    classnumsfirst.append(courseS+" "+"00"+courseN)
                }
                else if (courseN.count==2){
                    classnumsfirst.append(courseS+" "+"0"+courseN)
                }
                else{
                    classnumsfirst.append(courseS+" "+courseN)
                }
                let courseE = clas["section"] as! String
                    //                        self.classnums.append(CourseS+" "+CourseN)
                classsecfirst.append("Section "+courseE)
                }
                }else {
                    print ("error!")
                }
                self.myVar = status
                
                Lastname = jo["givenName"]! as! String
                
                // print("555",self.myVar)
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
    
    @IBAction func LoginButton(_ sender: UIButton) {
        login(TextInput.text!)
        //print(self.myVar)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
            {
                self.decide()
        })
        NetID = TextInput.text!
        uvmemail = NetID + "@uvm.edu"
        accesscode = Int(arc4random_uniform(999999) + 100000)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func viewClick(_ sender: AnyObject) {
        TextInput.resignFirstResponder()
        
    }
    func decide(){
        if self.myVar == "true"{
//            appDelegate.getRegion(netId: NetID)
//            appDelegate.loadRegions()
//            appDelegate.startMonitorRegions()
            
            let smtpSession = MCOSMTPSession()
            smtpSession.hostname = "smtp.gmail.com"
            smtpSession.username = "WeAttendance@gmail.com"
            smtpSession.password = "WeAttendance1234"
            smtpSession.port = 465
            smtpSession.authType = MCOAuthType.saslPlain
            smtpSession.connectionType = MCOConnectionType.TLS
            smtpSession.connectionLogger = {(connectionID, type, data) in
                if data != nil {
                    if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                        NSLog("Connectionlogger: \(string)")
                    }
                }
            }
            let builder = MCOMessageBuilder()
            builder.header.to = [MCOAddress(displayName: Lastname, mailbox: uvmemail)]
            builder.header.from = MCOAddress(displayName: "WEAttendance", mailbox: "WeAttendance@gmail.com")
            builder.header.subject = "WEAttendance Confirmation"
            builder.htmlBody="<p>Dear \(Lastname):<br /><br />You are using WEAttendance service. This is the access code: \(accesscode), please DO NOT share your access code with anybody. This access code can only be used once. If you are not using WEAttendance, please ignore this email. <br /><br />WEAttendance  </p>"
            
            
            let rfc822Data = builder.data()
            let sendOperation = smtpSession.sendOperation(with: rfc822Data)
            sendOperation?.start { (error) -> Void in
                if (error != nil) {
                    NSLog("Error sending email: \(String(describing: error))")
                    
                    
                } else {
                    NSLog("Successfully sent email!")
                    
                    
                }
            }
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Confirmation")
            self.present(newViewController, animated: false, completion: nil)
        }
        else if self.myVar == "false"{
            let alertController = UIAlertController(title: "Opps!", message: "This is not a correct NetID. Please try again!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
   
    
}

