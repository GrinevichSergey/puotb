//
//  Notes.swift
//  puotb
//
//  Created by Сергей Гриневич on 01/10/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit

class Notes: NSObject {
    
    var key: String?
    var title: String?
    var note: String?
    var date: NSNumber?
//    var imageUrl: String?
//    var imageWidth: NSNumber?
//    var imageHeight: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        key = dictionary["key"] as? String
        title = dictionary["title"] as? String
        note = dictionary["note"] as? String
        date = dictionary["date"] as? NSNumber
//        imageUrl = dictionary["imageUrl"] as? String
//        imageWidth = dictionary["imageWidth"] as? NSNumber
//        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        
    }
    
}
