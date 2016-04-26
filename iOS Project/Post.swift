//
//  Post.swift
//  iOS Test Project
//
//  Created by Bill Crews on 4/24/16.
//  Copyright © 2016 Bill Crews. All rights reserved.
//

import UIKit

class Post {
  
  var avatarImageUrl: String?
  var avatarImageData: NSData?
  var fullName: String?
  var message: String? 
  var pictureImageUrl: String?
  var pictureImageData: NSData?
  var replyCount: String?
  var createdDate: String?
 
  init(json: NSDictionary) {
    
        self.createdDate = json["created_dt"] as? String
        self.message = json["message"] as? String
        self.replyCount = json["reply_count"] as? String
        
        if let poster = json["poster"] as? NSDictionary {
          self.avatarImageUrl = poster["picture"] as? String
          let firstName = poster["first_name"] as? String
          let lastName = poster["last_name"] as? String
          self.fullName = firstName! + " " + lastName!
        }
        
        if let pictures = json["pictures"] as? NSArray {
          for picture in pictures {
            self.pictureImageUrl = picture["url"] as? String
          }
        }
        
      }
    }

