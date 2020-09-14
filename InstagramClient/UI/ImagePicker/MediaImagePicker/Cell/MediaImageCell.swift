//
//  MediaImageCell.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit
import AlamofireImage

final class MediaImageCell: BaseCollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicator.stopAnimating()
        imageView.image = nil
    }
    
}

// MARK: - MediaImageCellDisplayable

extension MediaImageCell: MediaImageCellDisplayable {
    
    func update(imageUrl: URL) {
        self.activityIndicator.startAnimating()
        
        self.imageView.af.setImage(withURL: imageUrl) { [weak self] _ in
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
