//
//  ImageOrientation.swift
//  CropImage
//
//  Created by Luis Enrique Segoviano Bonifacio on 18/02/22.
//

import UIKit

enum Orientation {
    case Portrait, Landscape, Square, unknown
}

final class ImageOrientation {
    
    static let shared = ImageOrientation()
    
    func validate(forImage image: UIImage) -> Orientation {
        if image.size.width > image.size.height {
            return .Landscape
        }
        if image.size.height > image.size.width {
            return .Portrait
        }
        if image.size.height == image.size.width {
            return .Square
        }
        return .unknown
    }
    
}
