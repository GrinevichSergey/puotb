//
//  Extensions.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 10/09/2019.
//  Copyright © 2019 Green. All rights reserved.
//


//Метод сжимает изображение
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    

    
    func loadImageCacheWidthUrlString(urlString: String)  {
        
        self.image = nil
        //check image for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject ) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise for off
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error ) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let dowloadedImage = UIImage(data: data!) {
                    imageCache.setObject(dowloadedImage, forKey: urlString as AnyObject)
                      self.image = dowloadedImage
                }
             
                
             
            }
            
            } .resume()
    }
    
}
