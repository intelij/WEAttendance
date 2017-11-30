//
//  Confirmation.swift
//  WEAttendance
//
//  Created by shan on 11/19/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class Confirmation: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var codeText: UITextField!
    
    @IBOutlet weak var emailnoteText: UILabel!
    
    
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        emailnoteText.text = "We just sent an email to "+uvmemail+" with confirmation code, please enter it here:"
        print(emailnoteText)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAgainButton(_ sender: UIButton) {
        accesscode = Int(arc4random_uniform(999999) + 100000)
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
    }
    
    @IBAction func enterCodeButton(_ sender: UIButton) {
        if (codeText.isEqual(accesscode)){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ClassList")
            self.present(newViewController, animated: false, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Opps!", message: "This is not a correct confirmation code. Please try again!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
   
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


