//
//  ImagePickerAssembly.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Swinject

final class ImagePickerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.autoregister(ImagePickerProtocol.self, initializer: ImagePicker.init)
            .inObjectScope(.transient)
        
        container.autoregister(ImageSourceProvidable.self, initializer: ImageSourceProvider.init)
            .inObjectScope(.transient)
        
        container.register(ImageSourceSelectable.self) { _ in
            ImageSourceSelector(sourceTypes: AppConstants.supportedSourceTypes)
        }.inObjectScope(.transient)
    }
    
}
