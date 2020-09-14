//
//  PermissionsManager.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import AVKit

protocol PermissionsManagable {
    
    func requestCameraAccess(completion: @escaping (Bool) -> Void)
    
}

final class PermissionsManager {}

// MARK: - PermissionsManagable

extension PermissionsManager: PermissionsManagable {
    
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async { completion(granted) }
        }
    }
    
}
