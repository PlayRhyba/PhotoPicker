//
//  MediaImagePickerViewController.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

final class MediaImagePickerViewController: BaseViewController {
    
    private struct Constants {
        
        static let cellsInRow: CGFloat = 2
        static let sidePadding: CGFloat = 1
        static let topPadding: CGFloat = 1
        static let bottomPadding: CGFloat = 1
        static let lineSpacing: CGFloat = 2
        static let interitemSpacing: CGFloat = 2
        
    }
    
    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .lightGray
        view.contentInsetAdjustmentBehavior = .always
        
        view.delegate = self
        view.dataSource = self
        
        view.register(UINib(nibName: MediaImageCell.reuseIdentifier, bundle: nil),
                      forCellWithReuseIdentifier: MediaImageCell.reuseIdentifier)
        
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.hidesWhenStopped = true
        
        return view
    }()
    
    private(set) lazy var cancelButton = UIButton.makeBarButton(title: "Cancel",
                                                                titleColor: .black,
                                                                target: self,
                                                                action: #selector(cancel))
    
    // MARK: - Initialization
    
    init(presenter: MediaImagePickerPresentable) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("will never happen")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSubviews()
    }
    
}

// MARK: - UICollectionViewDataSource

extension MediaImagePickerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getPresenter()?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaImageCell.reuseIdentifier,
                                                            for: indexPath) as? MediaImageCell,
            let cellPresenter = getPresenter()?.cellPresenter(at: indexPath.row) else {
                return UICollectionViewCell()
        }
        
        cell.presenter = cellPresenter
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension MediaImagePickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getPresenter()?.selectItem(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let numberOfRows = collectionView.numberOfItems(inSection: indexPath.section)
        
        if indexPath.row == numberOfRows - 1 {
            getPresenter()?.loadNext()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MediaImagePickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width
            - 2 * Constants.sidePadding
            - Constants.interitemSpacing * (Constants.cellsInRow - 1)
        
        let cellWidth = availableWidth / Constants.cellsInRow
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.topPadding,
                            left: Constants.sidePadding,
                            bottom: Constants.bottomPadding,
                            right: Constants.sidePadding)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.interitemSpacing
    }
    
}

// MARK: - Actions

@objc
private extension MediaImagePickerViewController {
    
    func cancel() {
        getPresenter()?.cancel()
    }
    
}

// MARK: - MediaImagePickerDisplayable

extension MediaImagePickerViewController: MediaImagePickerDisplayable {
    
    func update(title: String?) {
        self.title = title
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - Private

private extension MediaImagePickerViewController {
    
    func getPresenter() -> MediaImagePickerPresentable? {
        return presenter as? MediaImagePickerPresentable
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
}
