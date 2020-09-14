//
//  InstagramAuthenticationError.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

struct InstagramAuthenticationError: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case errorType = "error_type"
        case code
        case errorMessage = "error_message"
        
    }
    
    let errorType: String
    let code: Int
    let errorMessage: String
    
}
