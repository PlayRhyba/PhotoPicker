//
//  ImageSourceSelector.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

protocol ImageSourceSelectable {
    
    func pickSource(screenNavigator: ScreenNavigatable,
                    completion: @escaping (ImageSourceType) -> Void,
                    cancellation: (() -> Void)?)
    
}

final class ImageSourceSelector {
    
    private let sourceTypes: [ImageSourceType]
    
    // MARK: - Initialization
    
    init(sourceTypes: [ImageSourceType]) {
        self.sourceTypes = sourceTypes
    }
    
}

// MARK: - ImageSourceSelectable

extension ImageSourceSelector: ImageSourceSelectable {
    
    func pickSource(screenNavigator: ScreenNavigatable,
                    completion: @escaping (ImageSourceType) -> Void,
                    cancellation: (() -> Void)?) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        sourceTypes.forEach { type in
            let action = UIAlertAction(title: type.title,
                                       style: .default) { _ in completion(type) }
            
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in cancellation?() }
        
        alert.addAction(cancelAction)
        
        screenNavigator.present(screen: alert, animated: true)
    }
    
}

