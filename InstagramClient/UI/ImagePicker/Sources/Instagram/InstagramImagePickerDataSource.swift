//
//  InstagramImagePickerDataSource.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Combine

final class InstagramImagePickerDataSource {
    
    private let instagramClient: InstagramClientProtocol
    
    // MARK: - Initialization
    
    init(instagramClient: InstagramClientProtocol) {
        self.instagramClient = instagramClient
    }
    
}

// MARK: - Adapters

extension MediaImageItem {
    
    init(instagramMediaItem: InstagramMediaItem) {
        id = instagramMediaItem.id
        url = instagramMediaItem.url
        preview = instagramMediaItem.url
    }
    
}

extension MediaImageCollection {
    
    init(instagramMediaCollection: InstagramMediaCollection) {
        items = instagramMediaCollection.items.map { MediaImageItem(instagramMediaItem: $0) }
        next = instagramMediaCollection.next
    }
    
}

// MARK: - MediaImagePickerDataSource

extension InstagramImagePickerDataSource: MediaImagePickerDataSource {
    
    var title: String? {
        return "Instagram"
    }
    
    func load(from position: PaginationPosition) -> AnyPublisher<MediaImageCollection, ICError> {
        return instagramClient.media(position: position)
            .map { MediaImageCollection(instagramMediaCollection: $0) }
            .eraseToAnyPublisher()
    }
    
}
