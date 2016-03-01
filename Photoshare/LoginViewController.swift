//
//  LoginViewController.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/2/29.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignin(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user:PFUser?, error:NSError?) -> Void in
            if(user != nil){
                print("you are logged in")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }

    @IBAction func onSignup(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if(success){
                print("created new user")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
