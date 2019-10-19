//
//  DetalInfoTelPuotb.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 06/03/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Foundation
import WebKit



class DetalInfoTelPuotb: UIViewController   {

    
    var textOfLabel: String = ""
    var i1 = false

   
    
    @IBOutlet weak var arm_name: UITextField!
    @IBOutlet weak var arm_ip: UITextField!
    @IBOutlet weak var arm_login: UITextField!
    @IBOutlet weak var arm_password: UITextField!
    @IBOutlet weak var arm_phone: UITextField!
    @IBOutlet weak var arm_roz: UITextField!
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "transition_tel" {
                  // let destinationVC = segue.destination as! ViewController
                 //  destinationVC.j1 = "Телефоны"
        }
    }
    
    @IBAction func back_click(_ sender: Any) {
        
           performSegue(withIdentifier: "transition_tel", sender: self)
    }
    
    @IBOutlet weak var edit_but: UIButton!
    
    @IBAction func EditButton(_ sender: Any) {
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.isEnabled = true

                let button = UIButton(frame: CGRect(x:(self.view.frame.width-100) / 2, y: 500, width: 100, height: 50))
                
                button.backgroundColor = UIColor.clear
                
                button.setTitle("Сохранить", for: .normal)
                button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
              //  button.addTarget(self, action: #selector(Update_info), for: .touchUpInside)
                
                self.view.addSubview(button)
                
            }
        }
        edit_but.isEnabled = false
}
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func get()  {

        var jsonResult = NSArray()
        let url = NSURL(string: "https://api.xpcom.ru/puotb/select_detal_info.php?item1="+textOfLabel+"")
        let data = NSData(contentsOf: url! as URL)
        jsonResult = try! JSONSerialization.jsonObject(with: data! as Data, options:
            JSONSerialization.ReadingOptions.mutableContainers)  as! NSArray
     
        var jsonElement = NSDictionary()
     
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary

     
            if let name = jsonElement["arm_name"] as? String,
                let ip = jsonElement["arm_ip"] as? String,
                let login = jsonElement["arm_login"] as? String,
                let note = jsonElement["arm_note"] as? String,
                let rozetka = jsonElement["arm_rozetka"] as? String,
                let armtelnumber = jsonElement["armtelnumber"] as? String
            {
               
                arm_name.text = name
                arm_ip.text = ip
                arm_login.text = login
                arm_password.text = note
                arm_phone.text = armtelnumber
                arm_roz.text = rozetka
            }
            

        }
       
        print(jsonResult) //this part works fine
        

    }
    
    @objc func Add_Info(){
        view.endEditing(true)
        
        var request = URLRequest(url: NSURL(string: "https://api.xpcom.ru/puotb/insert_grinevich.php")! as URL)
        request.httpMethod = "POST"
        
        let posttring = "arm_name=\(arm_name.text!)&arm_ip=\(arm_ip.text!)&arm_login=\(arm_login.text!)&arm_note=\(arm_password.text!)&arm_phone=\(arm_phone.text!)&arm_roz=\(arm_roz.text!)"

        request.httpBody = posttring.data(using: String.Encoding.utf8)

//        let task = URLSession.shared.dataTask(with: request as URLRequest){
//            data, response, error in
//            if error != nil{
//                print("Ошибка в \(String(describing: error))")
//                return; }
//            do {
//
//                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                if let parseJSON = myJSON {
//                    var messsg: String!
//                    messsg = parseJSON["message"] as! String?
//                  //  print(messsg)
//                }
//            } catch {
//                print(error)
//            }
//        }

        //executing the task
       // task.resume()
        performSegue(withIdentifier: "transition_tel", sender: self)
        
    }
    
//    @objc func Update_info(){
//        view.endEditing(true)
//        
//        var request = URLRequest(url: NSURL(string: "https://api.xpcom.ru/puotb/update_grinevich.php")! as URL)
//        request.httpMethod = "POST"
//        
//       
//        
//        let posttring = "arm_name=\(arm_name.text!)&arm_ip=\(arm_ip.text!)&arm_login=\(arm_login.text!)&arm_note=\(arm_password.text!)&arm_phone=\(arm_phone.text!)&arm_roz=\(arm_roz.text!)&arm_id=\(textOfLabel)"
//        
//        print(posttring)
//        
//        request.httpBody = posttring.data(using: String.Encoding.utf8)
//        // let dataD = posttring.data(using: .utf8)
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest){
//            data, response, error in
//            if error != nil{
//                print("Ошибка в \(String(describing: error))")
//                return; }
//            do {
//                
//                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                if let parseJSON = myJSON {
//                    var messsg: String!
//                    messsg = parseJSON["message"] as! String?
//                    print(messsg ?? "")
//                }
//            } catch {
//                print(error)
//            }
//        }
//        
//        //executing the task
//        task.resume()
//        
//        
//        performSegue(withIdentifier: "transition_tel", sender: self)
//    }

    override func viewDidLoad() {
        print(self.view.intrinsicContentSize.width)
       
        super.viewDidLoad()
        if i1 == true
        {
            for view in self.view.subviews {
                if let textField = view as? UITextField {
                    textField.text = ""
                     textField.isEnabled = true
                    
                    let button = UIButton(frame: CGRect(x:(self.view.frame.width-100) / 2, y: 500, width: 100, height: 50))
                    
                    button.backgroundColor = UIColor.clear
                    
                    button.setTitle("Добавить", for: .normal)
                    button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
                    button.addTarget(self, action: #selector(Add_Info), for: .touchUpInside)
                    
                    self.view.addSubview(button)
                }
            }
              edit_but.isEnabled = false
        }
        else
        {
            get()
            for view in self.view.subviews {
                if let textField = view as? UITextField {
                    textField.isEnabled = false
                  
                }
            }
              edit_but.isEnabled = true
        }
       // self.arm_name.text = textOfLabel
    
    
        
    
    }
    
}
