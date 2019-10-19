//
//  StockModel.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 03/03/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit

class StockModel: NSObject {

    var id: String?
    var name: String?
    var ip : String?
    var login: String?
    var note: String?
    var tel : String?
    var rozetka: String?
    var password : String?
    var location : String?
    
    override init()
    {
        
    }
    
    //construct with @name and @price parameters
    
    init(id: String, name: String, ip: String, login: String, note: String, tel: String, rozetka: String, password: String, location: String) {
        
        self.id = id
        self.name = name
        self.ip = ip
        self.login = login
        self.note = note
        self.tel = tel
        self.rozetka = rozetka
        self.password = password
        self.location = location
        
    
    }
    
    //prints a stock's name and price
    
    override var description: String {
        return "arm_id: \(String(describing: id)), arm_name: \(String(describing: name)), arm_ip: \(String(describing: ip)), arm_login: \(String(describing: login)), arm_note: \(String(describing: note)), armtelnumber: \(String(describing: tel)), arm_rozetka: \(String(describing: rozetka)), arm_pass: \(String(describing: password)), arm_cat: \(String(describing: location))"

        
    }
}


//extension StockModel {
//    
//    var json: [String: Any] {
//        get {
//            var dictionary = [String: Any]()
//            dictionary["arm_id"] = id
//            dictionary["arm_name"] = name
//            dictionary["arm_ip"] = ip
//            dictionary["arm_login"] = login
//            dictionary["arm_note"] = note
//            dictionary["armtelnumber"] = te]
//            dictionary["arm_rozetka"] = rozetka
//            dictionary["arm_pass"] = password
//            dictionary["arm_cat"] = location
//            return dictionary
//        }
//    }
//    
//    static func parse(jsonElement: [String: Any]) -> StockModel? {
//        let arm = { () -> StockModel? in
//            let rawId = jsonElement["arm_id"] as? String
//            let rawName = jsonElement["arm_name"] as? String
//            let rawIp = jsonElement["arm_ip"] as? String
//            let rawLogin = jsonElement["arm_login"] as? String
//            let rawNote = jsonElement["arm_note"] as? String
//            let rawTel = jsonElement["armtelnumber"] as? String
//            let rawRozetka = jsonElement["arm_rozetka"] as? String
//            let rawPassword = jsonElement["arm_pass"] as? String
//            let rawLocation = jsonElement["arm_cat"] as? String
//            
//            let armPUOTB = StockModel(id: rawId!, name: rawName!, ip: rawIp!, login: rawLogin!, note: rawNote!, tel: rawTel!, rozetka: rawRozetka!, password: rawPassword!, location: rawLocation!)
//            return armPUOTB
//            
//        }
//        return arm()
//    }
//}
