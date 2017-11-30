//
//  ClassList.swift
//  iAttendance
//
//  Created by shan on 10/22/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit




class ClassList: UIViewController {
    
    @IBOutlet weak var Coursestack: UIStackView!
    @IBOutlet weak var LoadIndicator: UIActivityIndicatorView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var NameLabel: UILabel!
   
    @IBAction func Yesbutton(_ sender: UIButton) {
        UserDefaults.standard.set(NetID, forKey: "NetID")
        appDelegate.getRegion(netId: (UserDefaults.standard.value(forKey: "NetID") as! String))
    }
    @IBAction func Nobutton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "NetID")
    }

    override func viewDidLoad() {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        NameLabel.text =  Lastname + ", here are your classes:"
        LoadIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge
        LoadIndicator.center = view.center
        LoadIndicator.hidesWhenStopped = true
        self.LoadIndicator.startAnimating()
        super.viewDidLoad()
    }
    
    let delayTime = DispatchTime.now() + 1
    
    override func viewDidAppear(_ animated: Bool){
        if (Numclass != 0){
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.display()
            }

        }else {
            let alertController = UIAlertController(title: "Opps!", message: "You do not have class on your record now. Please contact with registrar office!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginID")
                self.present(newViewController, animated: false, completion: nil)
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func display(){
//        let stackView   = UIStackView()
//        stackView.axis  = UILayoutConstraintAxis.vertical
//        stackView.distribution  = UIStackViewDistribution.equalSpacing
//        stackView.alignment = UIStackViewAlignment.center
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
        //Constraints
//        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        for i in 0...Numclass-1{
            let Csubnum = UILabel()
            Csubnum.backgroundColor = UIColor(red:0.69, green:0.69, blue:0.69, alpha: 0.5)
            Csubnum.font = UIFont(name:"Helvetica" ,size: 20)
            Csubnum.widthAnchor.constraint(equalToConstant: self.Coursestack.frame.width).isActive = true
            Csubnum.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            Csubnum.text = classnumsfirst[i]+"         "+classsecfirst[i]
            Csubnum.textAlignment = .center
           // Csubnum.font = Csubnum.font.withSize(30)
            Csubnum.textColor = UIColor.white
            Coursestack.addArrangedSubview(Csubnum)
        
        }
       self.LoadIndicator.stopAnimating()
   }
}
