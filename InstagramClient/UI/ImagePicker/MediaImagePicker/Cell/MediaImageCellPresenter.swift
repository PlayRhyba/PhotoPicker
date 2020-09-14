//
//  MediaImageCellPresenter.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

protocol MediaImageCellDisplayable: ViewProtocol {
    
    func update(imageUrl: URL)
    
}

protocol MediaImageCellPresentable: ReusableCellPresentable {
    
    var item: MediaImageItem { get }
    
}

final class MediaImageCellPresenter: ReusableCellPresenter, MediaImageCellPresentable {
    
    let item: MediaImageItem
    
    // MARK: - Initialization
    
    init(item: MediaImageItem) {
        self.item = item
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAttach() {
        super.viewDidAttach()
        getView()?.update(imageUrl: item.preview)
    }
    
}

// MARK: - Private

private extension MediaImageCellPresenter {
    
    func getView() -> MediaImageCellDisplayable? {
        return view as? MediaImageCellDisplayable
    }
    
}
