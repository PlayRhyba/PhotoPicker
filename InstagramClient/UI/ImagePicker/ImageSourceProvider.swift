//
//  ImageSourceProvider.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

protocol ImageSourceProvidable {
    
    func imageSource(for sourceType: ImageSourceType) -> ImageSourceProtocol
    
}

final class ImageSourceProvider {
    
    private let permissionsManager: PermissionsManagable
    private let instagramClient: InstagramClientProtocol
    
    // MARK: - Initialization
    
    init(permissionsManager: PermissionsManagable,
         instagramClient: InstagramClientProtocol) {
        self.permissionsManager = permissionsManager
        self.instagramClient = instagramClient
    }
    
}

// MARK: - ImageSourceProvidable

extension ImageSourceProvider: ImageSourceProvidable {
    
    func imageSource(for sourceType: ImageSourceType) -> ImageSourceProtocol {
        switch sourceType {
        case .instagram:
            return InstagramImageSource(instagramClient: instagramClient)
        case .camera:
            return CameraImageSource(permissionsManager: permissionsManager,
                                     sourceType: .camera)
        case .gallery:
            return CameraImageSource(permissionsManager: permissionsManager,
                                     sourceType: .gallery)
        }
    }
    
}
