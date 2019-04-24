//
//  UIImageView.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//
import UIKit

extension UIImageView {
    func roundedImage(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func setImageFromURL(imageURLString: String){
        let imageURL = URL(string: imageURLString)
        var image: UIImage
        if let imageData = try? Data(contentsOf: imageURL!)
        {
            image = UIImage(data: imageData)!
        }else{
            image = #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")
        }
        
        self.image = image
    }
}
