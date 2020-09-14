//
//  InstagramLoginManager.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import WebKit
import Combine

protocol InstagramLoginManagerProtocol {
    
    func logIn(permissions: [String],
               from viewController: UIViewController?) -> AnyPublisher<String, ICError>
    
}

final class InstagramLoginManager {
    
    private typealias Completion = (_ code: String?, _ error: ICError?) -> Void
    
    private weak var authorizationWindow: InstagramAuthorizationWindow?
    private var completion: Completion?
    
}

// MARK: - InstagramLoginManagerProtocol

extension InstagramLoginManager: InstagramLoginManagerProtocol {
    
    func logIn(permissions: [String],
               from viewController: UIViewController?) -> AnyPublisher<String, ICError> {
        return Future { promise in
            self.logIn(permissions: permissions, from: viewController) { code, error in
                if let error = error {
                    promise(.failure(error))
                } else if let code = code {
                    promise(.success(code))
                } else {
                    promise(.failure(.noDataAvailable))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

// MARK: - InstagramAuthorizationWindowDelegate

extension InstagramLoginManager: InstagramAuthorizationWindowDelegate {
    
    func authorizationWindow(_ window: InstagramAuthorizationWindow,
                             didRedirect request: URLRequest,
                             decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = request.url,
            url.absoluteString.hasPrefix(Environment.instagramRedirectUri) else {
                decisionHandler(.allow)
                
                return
        }
        
        decisionHandler(.cancel)
        
        if let code = url.queryItemValue(for: "code") {
            handleSuccess(code: code)
        } else {
            let error = url.queryItemValue(for: "error")
            let reason =  url.queryItemValue(for: "error_reason")
            let description = url.queryItemValue(for: "error_description")
            
            handleFailure(error: .cancelledAuthorization(error, reason, description))
        }
    }
    
    func authorizationWindow(_ window: InstagramAuthorizationWindow,
                             didFail error: Error) {
        handleFailure(error: ICError.authorizationWindow(error))
    }
    
    func didCancelAuthorizationWindow(_ window: InstagramAuthorizationWindow) {
        handleFailure(error: .cancelled)
    }
    
}

// MARK: - Private

private extension InstagramLoginManager {
    
    func loginRequestURL(permissions: [String]) -> URL {
        let scope = permissions.joined(separator: ",")
        
        let queryItems = [URLQueryItem(name: "client_id", value: Environment.instagramAppId),
                          URLQueryItem(name: "redirect_uri", value: Environment.instagramRedirectUri),
                          URLQueryItem(name: "scope", value: scope),
                          URLQueryItem(name: "response_type", value: "code")]
        
        return AppConstants.instagramAuthURL
            .appendingPathComponent("authorize")
            .appending(queryItems: queryItems)
    }
    
    func handleSuccess(code: String) {
        authorizationWindow?.dismiss(animated: true) { [weak self] in
            self?.completion?(code, nil)
        }
    }
    
    func handleFailure(error: ICError) {
        authorizationWindow?.dismiss(animated: true) { [weak self] in
            self?.completion?(nil, error)
        }
    }
    
    private func logIn(permissions: [String],
                       from viewController: UIViewController?,
                       completion: @escaping Completion) {
        self.completion = completion
        
        guard let viewController = viewController ?? UIWindow.key?.currentViewController else {
            handleFailure(error: .internalError)
            
            return
        }
        
        let requestURL = loginRequestURL(permissions: permissions)
        let authorizationWindow = InstagramAuthorizationWindow(requestURL: requestURL)
        authorizationWindow.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authorizationWindow)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
        
        self.authorizationWindow = authorizationWindow
    }
    
}
