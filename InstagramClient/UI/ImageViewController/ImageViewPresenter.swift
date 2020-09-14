//
//  ImageViewPresenter.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

protocol ImageViewDisplayable: ViewProtocol {
    
    func update(imageURL: URL?)
    
}

protocol ImageViewPresentable: ScreenPresentable {
    
    var imagePicker: ImagePickerProtocol { get set }
    
    func pickImage()
    
}

final class ImageViewPresenter: ScreenPresenter {
    
    var imagePicker: ImagePickerProtocol
    
    // MARK: - Initialization
    
    init(imagePicker: ImagePickerProtocol) {
        self.imagePicker = imagePicker
    }
    
}

// MARK: - ImageViewPresentable

extension ImageViewPresenter: ImageViewPresentable {
    
    func pickImage() {
        imagePicker.pickImage { [weak self] (url, _) in
            self?.getView()?.update(imageURL: url)
        }
    }
    
}

// MARK: - Private

private extension ImageViewPresenter {
    
    func getView() -> ImageViewDisplayable? {
        return view as? ImageViewDisplayable
    }
    
}
