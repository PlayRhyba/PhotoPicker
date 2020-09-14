//
//  InstagramMediaError.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 10.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

struct InstagramMediaError: Codable, Equatable {
    
    let message: String
    let type: String
    let code: Int
    
}

// MARK: - Utilities

extension InstagramMediaError {
    
    var isOAuthException: Bool {
        return type == "OAuthException"
    }
    
}
