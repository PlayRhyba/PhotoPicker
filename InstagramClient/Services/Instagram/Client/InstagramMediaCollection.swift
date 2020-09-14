//
//  InstagramMediaCollection.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 10.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

struct InstagramMediaItem {
    
    let id: String
    let url: URL
    let timestamp: Date
    
    // MARK: - Initialization
    
    init(id: String,
         url: URL,
         timestamp: Date) {
        self.id = id
        self.url = url
        self.timestamp = timestamp
    }
    
    init(media: InstagramMedia) {
        id = media.id
        url = media.mediaUrl
        timestamp = media.timestamp
    }
    
}

struct InstagramMediaCollection {
    
    let items: [InstagramMediaItem]
    let next: URL?
    
}

// MARK: - InstagramMediaItem: Comparable

extension InstagramMediaItem: Comparable {
    
    static func < (lhs: InstagramMediaItem, rhs: InstagramMediaItem) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
}
