//
//  InstagramAuthenticator.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation
import Combine

protocol InstagramAuthenticatorProtocol {
    
    var accessToken: String? { get }
    
    func authenticate() -> AnyPublisher<String, ICError>
    func forget()
    
}

final class InstagramAuthenticator {
    
    private struct Constants {
        
        static let permissions = ["user_profile", "user_media"]
        static let instagramAccessTokenKey = "instagramAccessToken"
        
    }
    
    private let httpClient: HttpClientProtocol
    private let loginManager: InstagramLoginManagerProtocol
    private let storage: UserDataStorageProtocol
    private let websiteDataManager: WebsiteDataManagerProtocol
    
    // MARK: - Initialization
    
    init(httpClient: HttpClientProtocol,
         loginManager: InstagramLoginManagerProtocol,
         storage: UserDataStorageProtocol,
         websiteDataManager: WebsiteDataManagerProtocol) {
        self.httpClient = httpClient
        self.loginManager = loginManager
        self.storage = storage
        self.websiteDataManager = websiteDataManager
    }
    
}

// MARK: - InstagramAuthenticatorProtocol

extension InstagramAuthenticator: InstagramAuthenticatorProtocol {
    
    var accessToken: String? {
        get {
            return storage.value(forKey: Constants.instagramAccessTokenKey) as? String
        }
        set {
            if let value = newValue {
                storage.save(value, forKey: Constants.instagramAccessTokenKey)
            } else {
                storage.deleteValue(forKey: Constants.instagramAccessTokenKey)
            }
        }
    }
    
    func authenticate() -> AnyPublisher<String, ICError> {
        if accessToken == nil {
            websiteDataManager.clearInstagramData()
        }
        
        return loginManager.logIn(permissions: Constants.permissions, from: nil)
            .flatMap { [weak self] code -> AnyPublisher<String, ICError> in
                guard let self = self else { return Fail(error: .internalError).eraseToAnyPublisher() }
                
                let url = AppConstants.instagramAuthURL.appendingPathComponent("access_token")
                let parameters = self.makeAccessTokenParameters(code: code)
                
                return self.httpClient.post(url: url, parameters: parameters)
                    .tryMap { try $0.handleInstagramAuthenticationResponse() }
                    .mapError { .failedAuthentication($0) }
                    .map { $0.accessToken }
                    .handleEvents(receiveOutput: { [weak self] in self?.accessToken = $0 },
                                  receiveCompletion: { [weak self] in if case .failure = $0 { self?.accessToken = nil } })
                    .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func forget() {
        accessToken = nil
        websiteDataManager.clearInstagramData()
    }
    
}

// MARK: - Private

private extension InstagramAuthenticator {
    
    func makeAccessTokenParameters(code: String) -> [String: String] {
        return ["client_id": Environment.instagramAppId,
                "client_secret": Environment.instagramAppSecret,
                "grant_type": "authorization_code",
                "redirect_uri": Environment.instagramRedirectUri,
                "code": code]
    }
    
}

private extension Data {
    
    func handleInstagramAuthenticationResponse() throws -> InstagramAccessToken {
        if let object: InstagramAccessToken = extractObject(decoder: JSONDecoder.facebook) {
            return object
        } else if let error: InstagramAuthenticationError = extractObject(decoder: JSONDecoder.facebook) {
            throw ICError.rejectedAuthentication(error)
        } else {
            throw ICError.noDataAvailable
        }
    }
    
}
