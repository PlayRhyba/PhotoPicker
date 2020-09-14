//
//  ReusableCellPresentable.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

protocol ReusableCellDisplayable: ViewProtocol {
    
    static var reuseIdentifier: String { get }
    
}

extension ReusableCellDisplayable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

protocol ReusableCellPresentable: ViewPresentable {}

class ReusableCellPresenter: ViewPresenter, ReusableCellPresentable {}
