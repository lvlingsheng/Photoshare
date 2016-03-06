//
//  Userprofile.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/3/3.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit
import Parse

class Userprofile: NSObject {
    var userAvatar: UIImage?
    var userAvatarFile: PFFile?
    
    init(object: PFObject) {
        //print(object)
        userAvatarFile = object["Avatar"] as? PFFile
    }
    
    class func postUserAvatar(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserAvatar")
        
        // Add relevant fields to the object
        media["Avatar"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "avatar.png", data: imageData)
            }
        }
        return nil
    }
    
    class func processFilesWithavatarArray(array: [Userprofile], completion: () -> ()) {
        let group = dispatch_group_create()
        for userprofile in array {
            print(userprofile.userAvatarFile)
            if let file = userprofile.userAvatarFile {
                dispatch_group_enter(group)
                file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        userprofile.userAvatar = UIImage(data: data!)
                    }
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            print("converted all images")
            completion()
        }
    }
    
    class func mediaWithArray(array: [PFObject]) -> [Userprofile] {
        var myavatar = [Userprofile]()
        
        for object in array {
            myavatar.append(Userprofile(object: object))
        }
        
        return myavatar
    }
}
