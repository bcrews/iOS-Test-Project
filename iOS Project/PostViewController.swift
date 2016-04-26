//
//  PostViewController.swift
//  iOS Project
//
//  Created by Bill Crews on 4/25/16.
//  Copyright © 2016 Bill Crews. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController {
  
  var posts = [Post]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    automaticallyAdjustsScrollViewInsets = false
    tableView.estimatedRowHeight = 340.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    let url = NSURL(string: "https://dl.dropboxusercontent.com/s/svuljrx45pekiwe/posts.json?dl=0")!
    
    if let JSONData = NSData(contentsOfURL: url) {
    
          do {
            if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
              
              if let postArray = json["posts"] as? [NSDictionary] {
                for post in postArray {
                  self.posts.append(Post(json: post))
                }
              }
              
            }
          } catch {
            print("Error JSON Serialization")
          }
        }
  }
  
  override func viewWillAppear(animated: Bool) {
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return posts.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostTableViewCell
    
    let post = posts[indexPath.row]
    
    cell.layer.borderWidth = 1
    cell.layer.borderColor = UIColor(red: 230/255.0, green: 192/255.0, blue: 141/255.0, alpha: 1.0).CGColor
    
    cell.fullName.text = post.fullName
    cell.message.text = post.message
    if post.avatarImageUrl != nil {
      asyncLoadImage(post, imageUrl: post.avatarImageUrl!, imageView: cell.avatar)
      cell.avatar.layer.borderWidth = 2
      cell.avatar.layer.borderColor = UIColor(red: 204/255.0, green: 160/255.0, blue: 96/255.0, alpha: 1.0).CGColor
    }
    if post.pictureImageUrl != nil {
      asyncLoadImage(post, imageUrl: post.pictureImageUrl!, imageView: cell.picture)
      cell.contentView.addSubview(cell.picture)
     // cell.picture.sizeToFit()
      
    } else {
      cell.picture.removeFromSuperview()
    }
    cell.replies.text = post.replyCount
    cell.time.text = numberOfDaysFromStart(post.createdDate!)
    
    return cell
  }
  
}

extension PostViewController {
  
  func asyncLoadImage(post:Post,imageUrl:String, imageView: UIImageView) {
    
    let downloadQueue = dispatch_queue_create("posts.download", nil)
    
    dispatch_async(downloadQueue) {
      
      let data = NSData(contentsOfURL: NSURL(string:imageUrl)!)
      
      var image: UIImage?
      if data != nil {
        image = UIImage(data: data!)
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        imageView.image = image
      }
    }
  }
  
  func convertDate(date: String) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    let newDate = dateFormatter.dateFromString(date)
    dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm:ss"
    let reformatedDate = dateFormatter.stringFromDate(newDate!)
    return reformatedDate
  }

  func numberOfDaysFromStart(startDate: String) -> String   {
    
    let start = convertDate(startDate)
    let end = NSDate()
    
    let dateFormater = NSDateFormatter()
    dateFormater.dateFormat = "MM-dd-yyyy'T'HH:mm:ss"
    
    let startDate = dateFormater.dateFromString(start)
    let endDate = dateFormater.stringFromDate(end)
    
    let now = dateFormater.dateFromString(endDate)
    
    let cal = NSCalendar.currentCalendar()
    
    let components = cal.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: startDate!, toDate: now!, options: [])
    
    if components.year != 0 {
      return String("\(components.year) yr")
    } else if components.month != 0 {
      return String("\(components.month) mth")
    } else if components.day != 0 {
      return String("\(components.day) day")
    } else if components.hour != 0 {
      return String("\(components.hour) hr")
    } else if components.month != 0 {
      return String("\(components.minute) min")
    } else if components.second != 0 {
      return String("\(components.second) sec")
    } else {
      let newDateFormatter = NSDateFormatter()
      newDateFormatter.dateFormat = "MM-dd-yyyy"
      let newDate = newDateFormatter.stringFromDate(startDate!)
      return newDate
    }
    
    }

}

