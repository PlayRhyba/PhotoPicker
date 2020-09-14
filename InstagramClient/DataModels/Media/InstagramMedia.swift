//
//  InstagramMedia.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 10.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

struct InstagramMedia: Codable {
    
    enum MediaType: String, Codable {
        
        case image = "IMAGE"
        case video = "VIDEO"
        case album = "CAROUSEL_ALBUM"
        
    }
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        
        case id
        case mediaType = "media_type"
        case mediaUrl = "media_url"
        case timestamp
        
    }
    
    let id: String
    let mediaType: MediaType
    let mediaUrl: URL
    let timestamp: Date
    
}

// MARK: - Utilities

extension InstagramMedia {
    
    static var fields: String {
        return CodingKeys.allCases
            .map { $0.rawValue }
            .joined(separator: ",")
    }
    
}
