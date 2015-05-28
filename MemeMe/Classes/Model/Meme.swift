//
//  Meme.swift
//  MemeMe
//
//  Created by Felipe Lloret on 26/05/15.
//  Copyright (c) 2015 Felipe Lloret. All rights reserved.
//

import UIKit

class Meme {
    
    var topString: String
    var bottomString: String
    var image: UIImage
    var memedImage: UIImage
    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.topString = top
        self.bottomString = bottom
        self.image = image
        self.memedImage = memedImage
    }
    
}
