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


class LoginID: UIViewController, UITextFieldDelegate {
    
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
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ClassList")
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

