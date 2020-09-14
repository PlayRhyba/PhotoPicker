//
//  AlertDisplayer.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

protocol AlertDisplayable {
    
    func showAlert(title: String,
                   message: String?,
                   completion: (() -> Void)?)
    
}

extension AlertDisplayable {
    
    func showAlert(title: String, message: String?) {
        showAlert(title: title, message: message, completion: nil)
    }
    
}

extension UIViewController: AlertDisplayable {
    
    func showAlert(title: String,
                   message: String?,
                   completion: (() -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { _ in completion?() }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}
