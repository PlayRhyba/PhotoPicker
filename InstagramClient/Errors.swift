//
//  Errors.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

enum ICError: Error {
    
    case cancelled
    case internalError
    case noDataAvailable
    case authorizationWindow(_ error: Error)
    case cancelledAuthorization(_ error: String?, _ errorReason: String?, _ errorDescription: String?)
    case rejectedAuthentication(_ error: InstagramAuthenticationError)
    case failedAuthentication(_ error: Error)
    case failedMediaRequest(_ error: Error)
    case failedMedia(_ error: InstagramMediaError)
    case cameraPermissionDenied
    
}
