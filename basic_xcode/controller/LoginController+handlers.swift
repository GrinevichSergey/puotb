//
//  LoginController+handlers.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 03/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit

extension AuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func HandleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Отмена")
        dismiss(animated: true, completion: nil)
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageForPicker: UIImage?
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           
            selectedImageForPicker = editingImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            selectedImageForPicker = originalImage
        }
        if let selectedImage = selectedImageForPicker {
           selectForImage.image = selectedImage
        }
        
       dismiss(animated: true, completion: nil)
    }
}
