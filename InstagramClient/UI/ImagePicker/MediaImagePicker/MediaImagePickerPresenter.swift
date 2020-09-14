//
//  MediaImagePickerPresenter.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation
import Combine

protocol MediaImagePickerDisplayable: ViewProtocol, AlertDisplayable {
    
    func update(title: String?)
    func reloadData()
    func showLoader()
    func hideLoader()
    
}

protocol MediaImagePickerDelegate: class {
    
    func didSelect(item: MediaImageItem)
    func didCancel()
    
}

protocol MediaImagePickerPresentable: ScreenPresentable {
    
    var delegate: MediaImagePickerDelegate? { get set }
    var numberOfItems: Int { get }
    
    func cellPresenter(at index: Int) -> MediaImageCellPresentable
    func selectItem(at index: Int)
    func loadNext()
    func cancel()
    
}

final class MediaImagePickerPresenter: ScreenPresenter {
    
    weak var delegate: MediaImagePickerDelegate?
    private let dataSource: MediaImagePickerDataSource
    private var cellPresenters: [MediaImageCellPresentable] = []
    private var nextUrl: URL?
    private var isLoadingNext = false
    
    // MARK: - Initialization
    
    init(dataSource: MediaImagePickerDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getView()?.update(title: dataSource.title)
        getView()?.showLoader()
        
        dataSource.load(from: .start)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.getView()?.hideLoader()
                
                if case .failure(let error) = completion {
                    self?.handle(error: error)
                }
                }, receiveValue: { [weak self] collection in
                    guard let self = self else { return }
                    
                    self.cellPresenters = collection.items.map { MediaImageCellPresenter(item: $0) }
                    self.nextUrl = collection.next
                    
                    self.getView()?.reloadData()
            }).store(in: &cancelBag)
    }
    
}

// MARK: - MediaImagePickerPresentable

extension MediaImagePickerPresenter: MediaImagePickerPresentable {
    
    var numberOfItems: Int {
        return cellPresenters.count
    }
    
    func cellPresenter(at index: Int) -> MediaImageCellPresentable {
        return cellPresenters[index]
    }
    
    func selectItem(at index: Int) {
        delegate?.didSelect(item: cellPresenters[index].item)
    }
    
    func loadNext() {
        guard let nextUrl = nextUrl,
            !isLoadingNext else { return }
        
        isLoadingNext = true
        
        dataSource.load(from: .page(nextUrl))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingNext = false
                
                if case .failure(let error) = completion {
                    self?.handle(error: error)
                }
                }, receiveValue: { [weak self] collection in
                    guard let self = self else { return }
                    
                    self.cellPresenters += collection.items.map { MediaImageCellPresenter(item: $0) }
                    self.nextUrl = collection.next
                    
                    self.getView()?.reloadData()
            }).store(in: &cancelBag)
    }
    
    func cancel() {
        delegate?.didCancel()
    }
    
}

// MARK: - Private

private extension MediaImagePickerPresenter {
    
    func getView() -> MediaImagePickerDisplayable? {
        return view as? MediaImagePickerDisplayable
    }
    
    func handle(error: ICError) {
        switch error {
        case .cancelled:
            delegate?.didCancel()
        default:
            getView()?.showAlert(title: "Error",
                                 message: error.localizedDescription)
        }
    }
    
}
