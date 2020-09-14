//
//  ImagePicker.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

protocol ImagePickerProtocol {
    
    typealias Completion = (_ imageUrl: URL?, _ error: ICError?) -> Void
    
    var presentingScreen: ScreenNavigatable? { get set }
    
    func pickImage(completion: Completion?)
    
}

final class ImagePicker {
    
    weak var presentingScreen: ScreenNavigatable?
    private var imageSource: ImageSourceProtocol?
    private var imageSourceSelector: ImageSourceSelectable
    private var imageSourceProvider: ImageSourceProvidable
    private var completion: Completion?
    
    // MARK: - Initialization
    
    init(imageSourceSelector: ImageSourceSelectable,
         imageSourceProvider: ImageSourceProvidable) {
        self.imageSourceSelector = imageSourceSelector
        self.imageSourceProvider = imageSourceProvider
    }
    
}

// MARK: - ImagePickerProtocol

extension ImagePicker: ImagePickerProtocol {
    
    func pickImage(completion: Completion?) {
        guard let presentingScreen = presentingScreen else { return }
        
        self.completion = completion
        
        imageSourceSelector.pickSource(screenNavigator: presentingScreen,
                                       completion: { [weak self] in self?.pickImage(sourceType: $0, completion: completion) },
                                       cancellation: { [weak self] in self?.completion?(nil, .cancelled) })
    }
    
}

// MARK: - Private

private extension ImagePicker {
    
    func pickImage(sourceType: ImageSourceType, completion: Completion?) {
        imageSource = imageSourceProvider.imageSource(for: sourceType)
        imageSource?.presentingScreen = presentingScreen
        
        imageSource?.pickImage { [weak self] url, _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.completion?(nil, error)
                
                return
            }
            
            guard let url = url else {
                self.completion?(nil, .noDataAvailable)
                
                return
            }
            
            self.completion?(url, nil)
        }
    }
    
}

