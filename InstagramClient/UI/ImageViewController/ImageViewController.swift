//
//  ImageViewController.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit
import AlamofireImage

final class ImageViewController: BaseViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
}

// MARK: - IBActions

private extension ImageViewController {
    
    @IBAction func pickButtonClicked() {
        getPresenter()?.pickImage()
    }
    
}

// MARK: - ImageViewDisplayable

extension ImageViewController: ImageViewDisplayable {
    
    func update(imageURL: URL?) {
        guard let url = imageURL else { return }
        
        imageView.af.setImage(withURL: url)
    }
    
}

// MARK: - Private

private extension ImageViewController {
    
    func getPresenter() -> ImageViewPresentable? {
        return presenter as? ImageViewPresentable
    }
    
}
