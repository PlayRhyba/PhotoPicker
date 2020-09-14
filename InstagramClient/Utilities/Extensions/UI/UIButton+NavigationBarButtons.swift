//
//  UIButton+NavigationBarButtons.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func makeBarButton(title: String,
                              titleColor: UIColor,
                              target: Any?,
                              action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(titleColor, for: .normal)
        
        button.addTarget(target,
                         action: action,
                         for: .touchUpInside)
        
        return button
    }
    
}
