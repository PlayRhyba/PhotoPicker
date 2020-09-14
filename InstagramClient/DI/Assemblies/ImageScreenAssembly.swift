//
//  ImageScreenAssembly.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Swinject

final class ImageScreenAssembly: Assembly {
    
    func assemble(container: Container) {
        container.storyboardInitCompleted(ImageViewController.self) { r, vc in
            let presenter = r.resolve(ImageViewPresentable.self)
            presenter?.imagePicker.presentingScreen = vc
            vc.presenter = presenter
        }
        
        container.autoregister(ImageViewPresentable.self, initializer: ImageViewPresenter.init)
            .inObjectScope(.weak)
    }
    
}
