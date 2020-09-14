//
//  ImageSource.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

protocol ImageSourceProtocol {
    
    typealias Completion = (_ imageUrl: URL?,
        _ context: Any?,
        _ error: ICError?) -> Void
    
    var presentingScreen: ScreenNavigatable? { get set }
    
    func pickImage(completion: Completion?)
    
}
