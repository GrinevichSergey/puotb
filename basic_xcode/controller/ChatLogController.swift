//
//  ChatLogController.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 11/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var message = [Message]()
    let cellId = "cellId"
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите сообщение .... "
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    func observeMessages()  {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            //            print(snapshot)
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                //   let message = Message(dictionary: dictionary)
                //                message.fromID = dictionary["fromID"] as? String
                //                message.text = dictionary["text"] as? String
                //                message.timeStap = dictionary["timeStap"] as? NSNumber
                //                message.toID = dictionary["toId"] as? String
                //                message.imageUrl = dictionary["imageUrl"] as? String
                //                message.imageWidth = dictionary["imageWidth"] as? NSNumber
                //                message.imageHeight = dictionary["imageHeight"] as? NSNumber
                //
                // print("Сообщение ", message.text!)
                //                if message.chatPartnerId() == self.user?.id {
                //
                //
                //                }
                
                self.message.append(Message(dictionary: dictionary))
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    //scrol на посдений индекс
                    
                    self.collectionView?.scrollToItem(at: IndexPath(item: self.message.count - 1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
                    
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //     collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //        setupInputComponents()
        //
        setupKeyboardObservers()
        
        collectionView.keyboardDismissMode = .interactive
        
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //для вставки изображения
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "imageUpload")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        //разрешает нажатие
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        
        ////constraint x,y,w,h uploadImageView
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //кнопка отправить
        let sendButton = UIButton(type: .system )
        
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints  = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //constraint
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //текстовое поле для ввода сообщения
        
        containerView.addSubview(self.inputTextField)
        
        ////constraint
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        // inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        //линия
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        return containerView
    }()
    
    
    @objc func handleUploadTap()  {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            //
            uploadToFirebaseStorageUsingImage(selectedImage: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    private func uploadToFirebaseStorageUsingImage(selectedImage: UIImage)  {
        
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadDate = selectedImage.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadDate, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print("failed upload image: ", error!)
                    return
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Failed to download url:", error!)
                        return
                    }
                    
                    print("Image URL: \((url?.absoluteString)!)")
                    
                    self.sendMessageWithImageUrl(imageUrl: url!.absoluteString, image: selectedImage)
                })
                
            }
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    func setupKeyboardObservers()  {
        //        NotificationCenter.default.addObserver(
        //            self,
        //            selector: #selector(self.handleKeyboardWillShow),
        //            name: UIResponder.keyboardWillShowNotification,
        //            object: nil)
        //
        //        NotificationCenter.default.addObserver(
        //            self,
        //            selector: #selector(self.handleKeyboardWillHide),
        //            name: UIResponder.keyboardWillHideNotification,
        //            object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    //при открытии клавиатуры анимируется collectionView
    @objc func handleKeyboardDidShow() {
        if message.count > 0 {
            self.collectionView?.scrollToItem(at: IndexPath(item: self.message.count - 1, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification)  {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        // print(keyboardFrame)
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        //move the input area up somehow???
    }
    
    @objc func handleKeyboardWillHide(notification: Notification)  {
        
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self 
        
        let messages = message[indexPath.item]
        cell.textView.text = messages.text
        
        setupCell(cell: cell, message: messages)
        
        //lets modify the bubbleViews width somehow?
        if let text = messages.text {
            cell.bubbleWithAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
            
        } else if messages.imageUrl != nil {
            cell.bubbleWithAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        if let image = self.user?.profileImageUrl {
            cell.profileImageView.loadImageCacheWidthUrlString(urlString: image)
        }
        
        
        if message.fromID == Auth.auth().currentUser?.uid {
            //out blue message
            cell.bubbleView.backgroundColor = .blue
            cell.textView.textColor = .white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true
        } else {
            //in gray message
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageCacheWidthUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
            
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let messages = message[indexPath.item]
        if let text = messages.text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = messages.imageWidth?.floatValue, let imageHeight = messages.imageHeight?.floatValue {
            
            //h1 / w1 = h2 / w2
            //h2
            //h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.topViewController != self {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    
    @objc func handleSend() {
        let properties: [String: AnyObject] = ["text": inputTextField.text! as AnyObject]
        
        sendMessageWithProperties(propertioes: properties)
        
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        
        let priperties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        
        sendMessageWithProperties(propertioes: priperties)
    }
    
    private func sendMessageWithProperties(propertioes: [String: AnyObject]) {
        let ref  = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStap = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromID": fromId as AnyObject, "timeStap": timeStap]
        
        propertioes.forEach({values[$0] = $1})
        // childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
            guard let messageID = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageID)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageID)
            //            recepientUserMessagesRef.updateChildValues([messageID: 1])
            recipientUserMessagesRef.setValue(1)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    
    //my costom zooming logic
    func performZoomInForStartingImageView(startingImageView: UIImageView)  {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        // print(startingFrame)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow =  UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                //h2 / w1 = h1 / w1
                //h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                
                zoomingImageView.center = keyWindow.center
                
                
            }) { (completed) in
                //                zoomOutImageView.removeFromSuperview()
            }
            
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer)  {
        
        //        print("zoom")
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }) { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
            
        }
    }
}



//    //функция создания компонентов
//    func   setupInputComponents() {
//        let containerView = UIView()
//
//        containerView.backgroundColor = .white
////        containerView.backgroundColor = .red
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(containerView)
//
//        //constraint
//        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//
//         containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//         containerViewBottomAnchor?.isActive = true
//
//
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        //кнопка отправить
//        let sendButton = UIButton(type: .system )
//
//        sendButton.setTitle("Отправить", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints  = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        containerView.addSubview(sendButton)
//        //constraint
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        //текстовое поле для ввода сообщения
//
//        containerView.addSubview(inputTextField)
//
//        ////constraint
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
//        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//       // inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//
//        //линия
//        let separatorLineView = UIView()
//        separatorLineView.backgroundColor = UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0)
//        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(separatorLineView)
//
//        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//    }


