//
//  Menu.swift
//  iAttendance
//
//  Created by shan on 10/22/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit
import MessageUI

class Menu: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["zshan@uvm.edu"])
        mailComposeVC.setSubject("[Bug Report]We attendance")
        mailComposeVC.setMessageBody("This is an email to inform you a bug in WEATTEND app.", isHTML: false)
        return mailComposeVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Failed to send the mail", message: "You haven't set up your email address.Please set up it in your settings.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
    }
    
     @IBAction func CustumerButton(_ sender: UIButton) {
    if MFMailComposeViewController.canSendMail() {
    let mailComposeViewController = configuredMailComposeViewController()
        self.present(mailComposeViewController, animated: true, completion: nil)
    } else {
    self.showSendMailErrorAlert()
    }
        }
    
    @IBAction func locationSettingsBtn(_ sender: UIButton) {
        if !CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.openURL(url)
            }
        } else {
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.openURL(url)
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Cancelled.")
        case .sent:
            print("Success.")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    }



