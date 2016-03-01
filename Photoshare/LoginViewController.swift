//
//  LoginViewController.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/2/29.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit
import Parse
import TKSubmitTransition

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var btn: TKTransitionSubmitButton!
    var btn2: TKTransitionSubmitButton!
    @IBOutlet weak var btnFromNib: TKTransitionSubmitButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 44))
        
        btn.center = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height-180)
        //btn.center = self.view.center
        //btn.bottom = self.view.frame.height - 60
        btn.setTitle("Sign in", forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.addTarget(self, action: "buttononSignin:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        btn2 = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 44))
        
        btn2.center = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height-100)
        //btn.center = self.view.center
        //btn.bottom = self.view.frame.height - 60
        btn2.setTitle("Sign up", forState: .Normal)
        btn2.normalBackgroundColor = UIColor(red:0.51, green:0.84, blue:1.00, alpha:1.0)
        btn2.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn2.addTarget(self, action: "buttononSignup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn2)
        
        //self.view.bringSubviewToFront(self.btnFromNib)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didStartYourLoading() {
        btn.startLoadingAnimation()
    }
    
    func didFinishYourLoading() {
        btn.startFinishAnimation(1, completion: { () -> () in
            let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TimelineViewController")
            secondVC.transitioningDelegate = self
            
            self.presentViewController(secondVC, animated: true, completion: nil)
        })
    }
    
    
    @IBAction func buttononSignin(button: TKTransitionSubmitButton) {
        didStartYourLoading()
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user:PFUser?, error:NSError?) -> Void in
            if(user != nil){
                print("you are logged in")
                self.didFinishYourLoading()
                
            }else{
                button.failedAnimation(0, completion: nil)
            }
        }
    }

    
    @IBAction func buttononSignup(button:TKTransitionSubmitButton) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        btn2.startLoadingAnimation()
        newUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if(success){
                print("created new user")
                self.btn2.startFinishAnimation(1, completion: { () -> () in
                    let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TimelineViewController")
                    secondVC.transitioningDelegate = self
                    
                    self.presentViewController(secondVC, animated: true, completion: nil)
                })
            }else{
                print(error?.localizedDescription)
                button.failedAnimation(0, completion: nil)
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
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
