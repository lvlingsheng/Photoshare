//
//  TimelineViewController.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/3/1.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit
import Parse
import SwiftyDrop

let userDidLogoutNotification = "userDidLogoutNotification"
let offset_HeaderStop:CGFloat = 1000.0 // At this offset the Header stops its transformations



class TimelineViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var timelineTable: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var avatarImageHeight:CGFloat! = 50
    var avatarImage:UIImageView!
    var media: [UserMedia]!
    var avatar: [Userprofile]!
    var originalImage:UIImage!
    var editedImage:UIImage!
    
    //let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        timelineTable.dataSource = self
        timelineTable.delegate = self
        timelineTable.rowHeight = UITableViewAutomaticDimension
        timelineTable.estimatedRowHeight = 400
        

        // Do any additional setup after loading the view.

        
        userAvatar.clipsToBounds = true
        userAvatar.layer.cornerRadius = self.userAvatar.bounds.height/2
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
        userAvatar.userInteractionEnabled = true
        userAvatar.addGestureRecognizer(tap)
        
        
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                let tempMedia = UserMedia.mediaWithArray(media)
                UserMedia.processFilesWithArray(tempMedia, completion: { () -> Void in
                    print("reloading table")
                    self.timelineTable.reloadData()
                })
                self.media = tempMedia
                
            } else {
                // handle error
                print("error fetching data")
            }
        }
        
        let query_avatar = PFQuery(className: "UserAvatar")
        query_avatar.whereKey("author", equalTo: PFUser.currentUser()! )
        
        query_avatar.findObjectsInBackgroundWithBlock { (avatar:[PFObject]?, error:NSError?) -> Void in
            print("1")
            if let avatar = avatar {
                print(avatar[0])
                
                let file = avatar[avatar.count-1]["Avatar"]
                file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if error == nil {
                         self.userAvatar.image = UIImage(data: data!)
                         self.timelineTable.reloadData()
                    }
                })
                //self.userAvatar.image = tempavatar[0].userAvatar
                
            } else {
                // handle error
                print("error fetching data")
            }
        }
        

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let scrollView = self.scrollView{
            let offset = scrollView.contentOffset.y
            var avatarTransform = CATransform3DIdentity
            
            
            self.timelineTable.setHeight(396+offset)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / userAvatar.bounds.height  // Slow down the animation
            let avatarSizeVariation = ((userAvatar.bounds.height * (1.0 + avatarScaleFactor)) - userAvatar.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            
            
            
            userAvatar.layer.transform = avatarTransform

            //timelineTable.layer.transform = tableTransform
        }
    }
    
    func handleTap() {
        print("tap working")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            picker.dismissViewControllerAnimated(true, completion: nil)
            self.userAvatar.image = editedImage
            Userprofile.postUserAvatar(editedImage) { (success:Bool, error:NSError?) -> Void in
                if success {
                    print("upload successfully")
                    self.timelineTable.reloadData()
                }else{
                    print(error)
                }
            }
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        PFUser.logOut()
        Drop.down("Logout Successfully", state: .Info, duration: 4, action: nil)
        
    }

    @IBAction func onTakePhoto(sender: AnyObject) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("captionViewController")

        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if media != nil {
//            return media.count
//        } else {
//            return 0
//        }
//    }
    
    func tableView(timelineTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = timelineTable.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell

        cell.media = media[indexPath.section]
        
        return cell
    }

    func tableView(timelineTable: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
        
    }
    
    func numberOfSectionsInTableView(timelineTable: UITableView) -> Int{
        if media != nil {
            return media.count
        } else {
            return 0
        }
    }
    
    func tableView(timelineTable: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1
        profileView.image = self.userAvatar.image
        
        let username=UILabel()
        username.frame = CGRect(x:50, y:10, width:200, height:30)
        // Use the section number to get the right URL
//        let photo=photos![section]
//        let image=photo["user"]
//        let usertitle=image!["full_name"] as! String
        username.text=PFUser.currentUser()?.username
//        let imageurl=image!["profile_picture"] as! String
//        
//        
//        let finalurl=NSURL(string: imageurl)
//        //print(finalurl!)
//        profileView.setImageWithURL(finalurl!)
        
        let createAt=UILabel()
        createAt.textAlignment = NSTextAlignment.Right
        createAt.textColor = UIColor.grayColor()
        createAt.frame = CGRect(x:240, y:10, width:70, height:30)
        createAt.font = UIFont(name:"AvenirNext-Regular", size:12)
        // Use the section number to get the right URL
        var date = media[section].createtime
        var unit = "s"
        var timeSince = abs(date!.timeIntervalSinceNow as Double)// in seconds
        let reductionComplete = lowestReached(unit, value: timeSince)
        
        while(reductionComplete != true){
            unit = "m";
            timeSince = round(timeSince / 60)
            if lowestReached(unit, value: timeSince) { break}
            
            unit = "h";
            timeSince = round(timeSince / 60)
            if lowestReached(unit, value: timeSince) { break}
            
            unit = "d";
            timeSince = round(timeSince / 24)
            if lowestReached(unit, value: timeSince) { break}
            
            unit = "w";
            timeSince = round(timeSince / 7)
            if lowestReached(unit, value: timeSince) { break}
            
            (unit, timeSince) = localizedDate(date!)
            break
        }
        
        let value = Int(timeSince)
        createAt.text = "\(value)\(unit) ago"
        
        headerView.addSubview(profileView)
        headerView.addSubview(username)
        headerView.addSubview(createAt)
        // Add a UILabel for the username here
        
        return headerView
    }

    
    func lowestReached(unit: String, value: Double) -> Bool {
        let value = Int(round(value))
        switch unit {
        case "s":
            return value < 60
        case "m":
            return value < 60
        case "h":
            return value < 24
        case "d":
            return value < 7
        case "w":
            return value < 4
        default: // include "w". cannot reduce weeks
            return true
        }
    }
    
    func localizedDate(date: NSDate) -> (unit: String, timeSince: Double) {
        var unit = "/"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M"
        let timeSince = Double(formatter.stringFromDate(date))!
        formatter.dateFormat = "d/yy"
        unit += formatter.stringFromDate(date)
        return (unit, timeSince)
    }
    
    func localizedTimestamp(date: NSDate) -> String {
        let (unit, timeSince) = localizedDate(date)
        let value = Int(timeSince)
        var l18n = "\(value)\(unit), "
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        l18n += formatter.stringFromDate(date)
        return l18n
    }
    

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle{
        return UIStatusBarStyle.LightContent
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "captionSegue"){
            let captionView = segue.destinationViewController as! captionViewController
            captionView.selectedImage.image = editedImage
            
        }
    }*/
    

}
