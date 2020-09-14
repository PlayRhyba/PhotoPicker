//
//  ScreenNavigatable.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

protocol ScreenNavigatable: class {
    
    typealias CompletionHandler = () -> Void
    
    var presentedScreen: ScreenNavigatable? { get }
    var presentingScreen: ScreenNavigatable? { get }
    
    func present(screen: UIViewController,
                 style: UIModalPresentationStyle,
                 animated: Bool,
                 completion: CompletionHandler?)
    
    func dismissPresentedScreen(animated: Bool, completion: CompletionHandler?)
    
}

extension ScreenNavigatable {
    
    func present(screen: UIViewController,
                 animated: Bool,
                 completion: CompletionHandler? = nil) {
        present(screen: screen,
                style: .fullScreen,
                animated: animated,
                completion: completion)
    }
    
}

// MARK: - ScreenNavigatable

extension UIViewController: ScreenNavigatable {
    
    var presentedScreen: ScreenNavigatable? {
        return presentedViewController
    }
    
    var presentingScreen: ScreenNavigatable? {
        return presentingViewController
    }
    
    func present(screen: UIViewController,
                 style: UIModalPresentationStyle,
                 animated: Bool,
                 completion: CompletionHandler? = nil) {
        screen.modalPresentationStyle = style
        
        present(screen, animated: animated, completion: completion)
    }
    
    func dismissPresentedScreen(animated: Bool,
                                completion: CompletionHandler?) {
        dismiss(animated: animated, completion: completion)
    }
    
}
