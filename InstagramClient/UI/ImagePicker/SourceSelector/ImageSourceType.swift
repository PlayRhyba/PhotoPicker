//
//  ImageSourceType.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

enum ImageSourceType {
    
    case instagram
    case camera
    case gallery
    
}

extension ImageSourceType {
    
    var title: String {
        switch self {
        case .instagram:
            return "Instagram"
        case .camera:
            return "Camera"
        case .gallery:
            return "Gallery"
        }
    }
    
}
