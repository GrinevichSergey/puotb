//
//  NewNoteViewController.swift
//  puotb
//
//  Created by Сергей Гриневич on 01/10/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase

class NewNoteViewController: UIViewController {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            // observeMessages()
        }
    }
    
    var note : [Notes]?
    var index: Int?
    var key: String?
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите заголовок .... "
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handlerCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handlerSaveNote))
        
        setupInputComponents()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let noteEdit = note {
            if let noteIndex = index {
                titleTextField.text = noteEdit[noteIndex].title
                noteTextView.text = noteEdit[noteIndex].note
                key = noteEdit[noteIndex].key
                
            }
            
        }
    }
    
    @objc func handlerCancel()  {
        self.navigationController?.popViewController(animated: true)
        // dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handlerSaveNote()  {
        
        sendMessageWithNoteProperties()
        
    }
    
    private func sendMessageWithNoteProperties() {
        
        if index != nil {
            
            let ref = Database.database().reference()
            let userRef = ref.child("notes").child(key!)
            let dateNote = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            let title = titleTextField.text
            let noteText =  noteTextView.text
            
            let values: [String: AnyObject] = ["date": dateNote as AnyObject, "title": title as AnyObject, "note": noteText as AnyObject]
            
            userRef.updateChildValues(values)
            self.titleTextField.text = nil
            self.noteTextView.text = nil
            
            self.navigationController?.popViewController(animated: true)
        
        } else {
            
            let ref = Database.database().reference().child("notes")
            
            let childRef = ref.childByAutoId()
            
            // let userId = user!.id!
            let dateNote = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            let title = titleTextField.text
            let noteText =  noteTextView.text
            
            let values: [String: AnyObject] = ["key": childRef.key as AnyObject, "date": dateNote as AnyObject, "title": title as AnyObject, "note": noteText as AnyObject]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error  != nil {
                    print(error!)
                    return
                }
                
                //  guard let noteId = childRef.key else {return}
                self.titleTextField.text = nil
                self.noteTextView.text = nil
                self.navigationController?.popViewController(animated: true)
                
            }
            
            
        }
        
        
    }
    
}


extension NewNoteViewController {
    
    func setupInputComponents()  {
        let borderGray = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        titleTextField.backgroundColor = .white
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Введите заголовок..."
        titleTextField.layer.borderColor = borderGray.cgColor
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 5
        
        containerView.addSubview(titleTextField)
        
        titleTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        
        
        noteTextView.backgroundColor = .white
        noteTextView.layer.borderColor = borderGray.cgColor
        noteTextView.layer.borderWidth = 0.5
        noteTextView.layer.cornerRadius = 5
        noteTextView.font = .systemFont(ofSize: 18)
        containerView.addSubview(noteTextView)
        
        noteTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100).isActive = true
        noteTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
    }
    
    
    
}
