//
//  MediaImagePickerDataSource.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation
import Combine

struct MediaImageItem {
    
    let id: String
    let url: URL
    let preview: URL
    
}

struct MediaImageCollection {
    
    let items: [MediaImageItem]
    let next: URL?
    
}

protocol MediaImagePickerDataSource {
    
    var title: String? { get }
    
    func load(from position: PaginationPosition) -> AnyPublisher<MediaImageCollection, ICError>
    
}
