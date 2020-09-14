//
//  InstagramImageSource.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

final class InstagramImageSource {
    
    weak var presentingScreen: ScreenNavigatable?
    private let instagramClient: InstagramClientProtocol
    private var completion: ImageSourceProtocol.Completion?
    
    // MARK: - Initialization
    
    init(instagramClient: InstagramClientProtocol) {
        self.instagramClient = instagramClient
    }
    
}

// MARK: - ImageSourceProtocol

extension InstagramImageSource: ImageSourceProtocol {
    
    func pickImage(completion: Completion?) {
        self.completion = completion
        
        let dataSource = InstagramImagePickerDataSource(instagramClient: instagramClient)
        
        let presenter = MediaImagePickerPresenter(dataSource: dataSource)
        presenter.delegate = self
        
        let vc = MediaImagePickerViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: vc)
        
        presentingScreen?.present(screen: navigationController, animated: true)
    }
    
}

// MARK: - MediaImagePickerDelegate

extension InstagramImageSource: MediaImagePickerDelegate {
    
    func didSelect(item: MediaImageItem) {
        presentingScreen?.dismissPresentedScreen(animated: true) { [weak self] in
            self?.completion?(item.url, nil, nil)
        }
    }
    
    func didCancel() {
        presentingScreen?.dismissPresentedScreen(animated: true) { [weak self] in
            self?.completion?(nil, nil, .cancelled)
        }
    }
    
}
