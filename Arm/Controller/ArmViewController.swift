//
//  ArmViewController.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 22/08/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit

class ArmViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ip: UITextField!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var roz: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var barItem: UINavigationItem!
    
    var selectedStock : StockModel = StockModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = selectedStock.name
        ip.text = selectedStock.ip
        login.text = selectedStock.login
        password.text = selectedStock.password
        tel.text = selectedStock.tel
        roz.text = selectedStock.rozetka
        notes.text = selectedStock.note
        barItem.title = selectedStock.location
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        if let currentArm = constructArm() {
            print(currentArm)
            
            var request = URLRequest(url: NSURL(string: "https://api.xpcom.ru/puotb/update_puotb.php")! as URL)
            request.httpMethod = "POST"
            
            let posttring = "arm_name=\(name.text!)&arm_ip=\(ip.text!)&arm_login=\(login.text!)&arm_note=\(notes.text!)&armtelnumber=\(tel.text!)&arm_rozetka=\(roz.text!)&arm_pass=\(password.text!)&arm_cat=\(currentArm.location!)&arm_id=\(currentArm.id!)"
            
            request.httpBody = posttring.data(using: String.Encoding.utf8)
//            let task = URLSession.shared.dataTask(with: request as URLRequest){
//                data, response, error in
//                if error != nil{
//                    print("Ошибка в \(String(describing: error))")
//                    return; }
//                do {
//                    let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                    if let parseJSON = myJSON {
//                        var messsg: String?
//                        messsg = parseJSON["message"] as! String?
//                        //print(messsg as Any)
//
//
//                    }
//                } catch {
//                    print("Ошибка в \(String(describing: error))")
//                }
//            }
//
//            task.resume()
        }
        
        
        
    }
    
    private func constructArm() -> StockModel? {
        guard let id = selectedStock.id else {return nil}
        guard let name = selectedStock.name else {return nil}
        guard let ip = selectedStock.ip else {return nil}
        guard let login = selectedStock.login else {return nil}
        guard let note = selectedStock.note else {return nil}
        guard let password = selectedStock.password else {return nil}
        guard let tel = selectedStock.tel else {return nil}
        guard let roz = selectedStock.rozetka else {return nil}
        guard let location = selectedStock.location else {return nil}
        
        
        if (name != "") && (login != "") && (password != "") && (tel != "") && (roz != "") {
            let arm = StockModel(id: id, name: name, ip: ip, login: login, note: note, tel: tel, rozetka: roz, password: password, location: location)
            
            return arm
        } else {
           
            return nil
        }
    }
    
    
    
    
}

