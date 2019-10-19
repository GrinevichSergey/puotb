//
//  AuthViewController.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 01/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var smenaField: UIPickerView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var selectForImage: UIImageView!
    var chartViewController: ChatViewController?
    
    @IBOutlet weak var ansText: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    private let smena = ["1 смена", "2 смена", "3 смена", "4 смена"]
    
    var signup: Bool = true {
        willSet {
            if newValue {
                titleLabel.text = "Регистрация"
                nameField.isHidden = false
               // smenaField.isHidden = false
                enterButton.setTitle("Вход", for: .normal)
                ansText.text = "У вас уже есть аккаунт?"
                btn.setTitle("Регистрация", for: .normal)
            } else
            {
                nameField.isHidden = true
              //  smenaField.isHidden = true
                titleLabel.text = "Вход"
                ansText.text = "У вас еще нет аккаунта?"
                enterButton.setTitle("Регистрация", for: .normal)
                btn.setTitle("Вход", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //smenaField.dataSource = self
        // smenaField.delegate = self
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
      //  smenaField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleSelectProfileImageView))
        selectForImage.addGestureRecognizer(tap)
        selectForImage.isUserInteractionEnabled = true
        
    }
    
    
    
    @IBAction func tappedButton(_ sender: Any) {
        signup = !signup
        
        
    }
    
    @IBAction func registerUser(_ sender: Any) {
       register()
    }
    
    func register()  {
        let name  = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        if (signup) {
            if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            
                            let imageName = NSUUID().uuidString
                            let storageRef = Storage.storage().reference().child("profileImage").child("\(imageName).jpg")
                          
                            if let profileImage = self.selectForImage.image, let uploadData =
                                profileImage.jpegData(compressionQuality: 0.1) {
                   
           
//                            if let uploadData = self.selectForImage.image!.pngData() {
                                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                    
                                    if error != nil {
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    
                                    storageRef.downloadURL(completion: { (url, error) in
                                        if error != nil {
                                            print("Failed to download url:", error!)
                                            return
                                        } else {
                                            //Do something with url
                                            if let profileImageUrl = url?.absoluteString {
                                                let values = ["name" : name, "email": email, "profileImageUrl": profileImageUrl]
                                                self.registerUserIntoDatabaseWithUID(uid: result.user.uid, values: values as [String : AnyObject])
                                            }
                                        }
                                        
                                    })
                                    
                                })
                            }
                            
                        }
                    }
                }
            } else {
                showAlert()
            }
        } else {
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error == nil {
                        self.chartViewController?.fetchUserAndSetupNavBarTitle()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }else {
                showAlert()
            }
        }

    }
    
}

extension AuthViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return smena.count
    }
    
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        <#code#>
    //    }
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return smena[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: smena[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attributedString
    }
    
    
    func showAlert()  {
        let alert  = UIAlertController(title: "Error", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid : String, values: [String: AnyObject]) {
        
        let ref =  Database.database().reference().child("users").child(uid)
        ref.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
          //  self.chartViewController?.fetchUserAndSetupNavBarTitle()
          //  self.chartViewController?.navigationItem.title = values["name"] as? String
            let user = User()
            user.name = values["name"] as? String
            user.email = values["email"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String
            self.chartViewController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    
}


extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        register()
        return true
    }
    
}



