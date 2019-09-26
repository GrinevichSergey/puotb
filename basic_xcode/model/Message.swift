//
//  Message.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 18/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    
    var fromID: String?
    var text: String?
    var timeStap: NSNumber?
    var toID: String?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    
    func chatPartnerId() -> String? {
        
        //  return (fromID == Auth.auth().currentUser?.uid ? toID : fromID)!
        if fromID == Auth.auth().currentUser?.uid {
            return toID
        } else {
            return fromID
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromID = dictionary["fromID"] as? String
        text = dictionary["text"] as? String
        timeStap = dictionary["timeStap"] as? NSNumber
        toID = dictionary["toId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        
    }
}
