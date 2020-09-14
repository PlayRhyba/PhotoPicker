//
//  CameraImageSource.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

final class CameraImageSource: NSObject {
    
    enum SourceType {
        
        case camera
        case gallery
        
    }
    
    weak var presentingScreen: ScreenNavigatable?
    private let permissionsManager: PermissionsManagable
    private let sourceType: SourceType
    private var completion: Completion?
    
    // MARK: - Initialization
    
    init(permissionsManager: PermissionsManagable,
         sourceType: SourceType) {
        self.permissionsManager = permissionsManager
        self.sourceType = sourceType
    }
    
}

// MARK: - ImageSourceProtocol

extension CameraImageSource: ImageSourceProtocol {
    
    func pickImage(completion: Completion?) {
        self.completion = completion
        
        permissionsManager.requestCameraAccess { [weak self] granted in
            guard let self = self else { return }
            
            guard granted else {
                self.completion?(nil, nil, .cameraPermissionDenied)
                
                return
            }
            
            let picker = UIImagePickerController()
            let pickerSourceType = self.sourceType.pickerSourceType
            
            picker.sourceType = UIImagePickerController.isSourceTypeAvailable(pickerSourceType) ?
                pickerSourceType :
                .photoLibrary
            
            picker.delegate = self
            
            self.presentingScreen?.present(screen: picker, animated: true)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension CameraImageSource: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            completion?(nil, nil, .noDataAvailable)
            
            return
        }
        
        presentingScreen?.dismissPresentedScreen(animated: true) { [weak self] in
            self?.completion?(url, nil, nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentingScreen?.dismissPresentedScreen(animated: true) { [weak self] in
            self?.completion?(nil, nil, .cancelled)
        }
    }
    
}

// MARK: - UINavigationControllerDelegate

extension CameraImageSource: UINavigationControllerDelegate {}

// MARK: - Utilities

private extension CameraImageSource.SourceType {
    
    var pickerSourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .gallery:
            return .photoLibrary
        }
    }
    
}
