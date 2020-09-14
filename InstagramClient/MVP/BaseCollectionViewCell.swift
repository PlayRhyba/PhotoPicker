//
//  BaseCollectionViewCell.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReusableCellDisplayable {
    
    var presenter: ViewPresentable? {
        didSet {
            if let presenter = presenter {
                presenter.attach(view: self)
            } else {
                presenter?.detachView()
            }
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        presenter?.detachView()
        presenter?.deinitialization()
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        presenter = nil
    }
    
}
