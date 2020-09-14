//
//  InstagramAccessToken.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

struct InstagramAccessToken: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case accessToken = "access_token"
        case userId = "user_id"
        
    }
    
    let accessToken: String
    let userId: Int
    
}
