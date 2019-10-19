//
//  ChatViewController.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 02/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellId = "cellId"
    var message = [Message]()
    var messageDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(HandlerLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Написать", style: .plain, target: self, action: #selector(HandleNewMessage))
        
        checkIfUserIsLogginIn()
        
        // observeMessages()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    func obserUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref  = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            //  print(snapshot)
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)

            }, withCancel: nil)

        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictioinary = snapshot.value as? [String: Any] {
                let message = Message(dictionary: dictioinary as [String : AnyObject])
//                message.fromID = dictioinary["fromID"] as? String
//                message.text = dictioinary["text"] as? String
//                message.timeStap = dictioinary["timeStap"] as? NSNumber
//                message.toID = dictioinary["toId"] as? String
//                message.imageUrl = dictioinary["imageUrl"] as? String
//                message.imageWidth = dictioinary["imageWidth"] as? NSNumber
//                message.imageHeight = dictioinary["imageHeight"] as? NSNumber
                //print(message.text)
                //  self.message.append(message)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messageDictionary[chatPartnerId] = message
                    
                    
                }
                
                self.attempReloadofTable()
                
            }
            
        }, withCancel: nil)
        
    }
    
    private func attempReloadofTable() {
        self.timer?.invalidate()
        //   print("we just canceled our timer")
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(self.handlerReloadTable), userInfo: nil, repeats: false)
        //  print("shedule a table reload in 0.1 sec")
    }
    
    var timer: Timer?
    
    @objc func handlerReloadTable() {
        self.message = Array(self.messageDictionary.values)
        self.message.sort(by: { (m1, m2) -> Bool in
            
            return m1.timeStap!.intValue > m2.timeStap!.intValue
            
        })
        
        DispatchQueue.main.async {
            //   print("we reloaded the table")
            self.tableView.reloadData()
        }
        
        
    }
    
    //    func observeMessages()  {
    //        let ref = Database.database().reference().child("messages")
    //
    //        ref.observe(.childAdded, with: { (snapshot) in
    //
    //
    //            if let dictioinary = snapshot.value as? [String: Any] {
    //                let message = Message()
    //                message.fromID = dictioinary["fromID"] as? String
    //                message.text = dictioinary["text"] as? String
    //                message.timeStap = dictioinary["timeStap"] as? NSNumber
    //                message.toID = dictioinary["toId"] as? String
    //                //print(message.text)
    //                //  self.message.append(message)
    //
    //                if let toId = message.toID {
    //                    self.messageDictionary[toId] = message
    //
    //                    self.message = Array(self.messageDictionary.values)
    //                    self.message.sort(by: { (m1, m2) -> Bool in
    //
    //                        return m1.timeStap!.intValue > m2.timeStap!.intValue
    //
    //                    })
    //                }
    //
    //                DispatchQueue.main.async {
    //                    self.tableView.reloadData()
    //                }
    //
    //            }
    //
    //
    //
    //            print(snapshot)
    //
    //        }, withCancel: nil)
    //    }
    //
    //
    @objc func HandleNewMessage()  {
        let newMessageController = NewMessageController()
        newMessageController.chatViewController = self
        present(UINavigationController(rootViewController: newMessageController), animated: true, completion: nil)
    }
    
    
    func checkIfUserIsLogginIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(HandlerLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
            
        }
    }
    
    
    @objc func HandlerLogout() {
        do {
            try Auth.auth().signOut()
        } catch  let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authViewController = storyboard.instantiateViewController(withIdentifier :"AuthViewController") as! AuthViewController
        authViewController.chartViewController = self
        self.present(authViewController, animated: true)
    }
    
    
    func fetchUserAndSetupNavBarTitle()  {
        
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //  self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                
                //ручками
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                //не работает
                //  user.setValuesForKeys(dictionary)
                print(user.email as Any)
                print(user.name as Any)
                self.setupNavBarWithUser(user: user)
            }
            
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User)  {
        
        message.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        obserUserMessages()
        
        let titleView = UIView()
        //  Get Rid Of The  titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        // It Causes Problems with Container constraints
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
        
        /***Add all the code below. This will set the titleView Constraints.***/
        
        // Make sure this is above the constraints and below all the other addSubviews
        titleView.addSubview(containerView)
        self.navigationItem.titleView = titleView
        
        titleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.centerXAnchor.constraint(equalTo: (self.navigationItem.titleView?.centerXAnchor)!).isActive = true
        titleView.centerYAnchor.constraint(equalTo: (self.navigationItem.titleView?.centerYAnchor)!).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        //        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        
    }
    
    @objc func showChatControllerForUser(user: User){
        //        print("123")
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}


//MARK:  TableView

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let messages = message[indexPath.row]
      
        cell.messages = messages
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messages = message[indexPath.row]
        //        print(messages.text!, messages.toID!, messages.fromID!)
        //
        guard let chatPartnerId = messages.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //            print(snapshot)
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            
            user.email = dictionary["email"] as? String
            user.name = dictionary["name"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
        
    }
    
}
