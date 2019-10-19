//
//  NoteViewController.swift
//  puotb
//
//  Created by Сергей Гриневич on 29/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase

class NoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let tableView = UITableView()
    var note = [Notes]()
    var noteDictionary = [String: Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Создать", style: .plain, target: self, action: #selector(HandlerNewNoteView))
        
         setupTableNotesView()

    }
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
       
        fetchUserAndSetupNavBarTitle()
    }
    
    private func attempReloadofTable() {
        self.timer?.invalidate()
        //   print("we just canceled our timer")
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(self.handlerReloadTable), userInfo: nil, repeats: false)
        //  print("shedule a table reload in 0.1 sec")
    }
    
    @objc func handlerReloadTable() {
        // self.note = Array(self.noteDictionary.values)
        self.note.sort(by: { (m1, m2) -> Bool in
            
            return m1.date!.intValue > m2.date!.intValue
            
        })
        
        DispatchQueue.main.async {
            print("we reloaded the table")
            self.tableView.reloadData()
        }
        
        
    }
    
    @objc func HandlerNewNoteView() {
        
        let newNoteViewController = NewNoteViewController()
        newNoteViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(newNoteViewController, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return note.count
    }
    
    var cellId = "cellId"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellNoteViewTable
////
//        cell.textLabel?.text = note[indexPath.row].title
//
//        cell.detailTextLabel?.text = note[indexPath.row].note

        let notes = note[indexPath.row]
        cell.note = notes
       // cell.textLabel?.textColor = UIColor.cyan
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newNoteCV = NewNoteViewController()
        if let selectedIndex = tableView.indexPathForSelectedRow?.row {
            newNoteCV.index = selectedIndex
        }

        newNoteCV.note = self.note

        navigationController?.pushViewController(newNoteCV, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            
            let ref = Database.database().reference().child("notes")
            let deleted: Notes = note[indexPath.row]
            let uk = deleted.key
            ref.child(uk!).removeValue()
            note.remove(at: indexPath.item)
            tableView.reloadData()
            
        }
    }
    
    func obserUserNotes() {
        
        let ref = Database.database().reference().child("notes")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let myNote = Notes(dictionary: dictionary as [String : AnyObject])
                self.note.append(myNote)
                
            }
            self.attempReloadofTable()
            
        }, withCancel: nil)
    }
    
    
    
}


extension NoteViewController {
    
    func setupTableNotesView()  {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
       

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CellNoteViewTable.self, forCellReuseIdentifier: cellId)
               

    }
    
    //MARK: SetNavBar
    
    func fetchUserAndSetupNavBarTitle()  {
        
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                //ручками
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                self.setupNavBarWithUser(user: user)
            }
            
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User)  {
        
        note.removeAll()
        // noteDictionary.removeAll()
        tableView.reloadData()
        
        obserUserNotes()
        
        let titleView = UIView()
        
        titleView.isUserInteractionEnabled = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageCacheWidthUrlString(urlString: profileImageUrl)
            
        }
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo:
            containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        titleView.addSubview(containerView)
        self.navigationItem.titleView = titleView
        
        titleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.centerXAnchor.constraint(equalTo: (self.navigationItem.titleView?.centerXAnchor)!).isActive = true
        titleView.centerYAnchor.constraint(equalTo: (self.navigationItem.titleView?.centerYAnchor)!).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
    }
    
    
}

