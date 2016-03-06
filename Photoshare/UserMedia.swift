//
//  UserMedia.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/3/1.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    
    var mediaFile: PFFile?
    var image: UIImage?
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var createtime: NSDate?
    
    init(image: UIImage, caption: String, likesCount: Int, commentsCount: Int) {
        self.image = image
        self.caption = caption
        self.likesCount = likesCount
        self.commentsCount = commentsCount
    }
    
    init(object: PFObject) {
        //print(object)
        mediaFile = object["media"] as? PFFile
        caption = object["caption"] as? String
        likesCount = object["likesCount"] as? Int
        commentsCount = object["commentsCount"] as? Int
        createtime = object["createtime"] as? NSDate
    }
    
    /**
     * Other methods
     */
     
     /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserMedia")
        
        // Add relevant fields to the object
        media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        media["createtime"] = NSDate()
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    

    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func processFilesWithArray(array: [UserMedia], completion: () -> ()) {
        let group = dispatch_group_create()
        for media in array {
            if let file = media.mediaFile {
                dispatch_group_enter(group)
                file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        media.image = UIImage(data: data!)
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
    

    
    class func mediaWithArray(array: [PFObject]) -> [UserMedia] {
        var media = [UserMedia]()
        
        for object in array {
            media.append(UserMedia(object: object))
        }
        
        return media
    }
}
