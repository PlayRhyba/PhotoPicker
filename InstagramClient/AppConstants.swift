//
//  Constants.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

struct AppConstants {
    
    static let instagramAuthURL = URL(string: "https://api.instagram.com/oauth/")!
    static let instagramGraphURL = URL(string: "https://graph.instagram.com/")!
    
    static let supportedSourceTypes: [ImageSourceType] = [.instagram, .camera, .gallery]
    
}
