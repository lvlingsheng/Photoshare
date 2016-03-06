//
//  captionViewController.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/3/1.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit
import TKSubmitTransition
import SwiftyDrop

class captionViewController: UIViewController,UIViewControllerTransitioningDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    var btn: TKTransitionSubmitButton!
    var originalImage:UIImage!
    var editedImage:UIImage!
    var haveset:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 200, height: 44))
        
        btn.center = CGPoint(x: 3*self.view.bounds.width / 4,
            y: self.view.bounds.height-310)
        //btn.center = self.view.center
        //btn.bottom = self.view.frame.height - 60
        btn.setTitle("Upload", forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.addTarget(self, action: "upload:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if(haveset == false){
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func upload(button: TKTransitionSubmitButton) {
        btn.startLoadingAnimation()
        UserMedia.postUserImage(editedImage, withCaption: captionField.text) { (success:Bool, error:NSError?) -> Void in
            if(success == true){
                Drop.down("Upload successfully", state: .Success, duration: 5, action: nil)
                self.btn.startFinishAnimation(0.6, completion: { () -> () in
                    
                    
                    let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TimelineViewController")
                    secondVC.transitioningDelegate = self
                    self.presentViewController(secondVC, animated: true, completion: nil)
                })
            }else{
                button.failedAnimation(0, completion: nil)
                Drop.down("Upload failed", state: .Warning, duration: 4, action: nil)
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            picker.dismissViewControllerAnimated(true, completion: nil)
            self.selectedImage.image = editedImage
            haveset = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
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
