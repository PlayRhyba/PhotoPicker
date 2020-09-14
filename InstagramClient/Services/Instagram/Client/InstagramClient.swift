//
//  InstagramClient.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 10.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation
import Combine

protocol InstagramClientProtocol {
    
    func media(position: PaginationPosition) -> AnyPublisher<InstagramMediaCollection, ICError>
    
}

final class InstagramClient {
    
    private struct Constants {
        
        static let mediaPageLimit = 20
        static let childrenPageLimit = 10
        
    }
    
    private enum RequestExecutionMode {
        
        case token(String)
        case authorization
        
    }
    
    private let authenticator: InstagramAuthenticatorProtocol
    private let httpClient: HttpClientProtocol
    
    // MARK: - Initialization
    
    init(authenticator: InstagramAuthenticatorProtocol,
         httpClient: HttpClientProtocol) {
        self.authenticator = authenticator
        self.httpClient = httpClient
    }
    
}

// MARK: - InstagramClientProtocol

extension InstagramClient: InstagramClientProtocol {
    
    func media(position: PaginationPosition) -> AnyPublisher<InstagramMediaCollection, ICError> {
        let mode: RequestExecutionMode = {
            if let accessToken = authenticator.accessToken {
                return .token(accessToken)
            }
            
            return .authorization
        }()
        
        return execute(mode: mode) { [weak self] token in
            guard let self = self else { return Fail(error: ICError.internalError).eraseToAnyPublisher() }
            
            return self.media(position: position, accessToken: token)
        }
    }
    
}

// MARK: - Requests

private extension InstagramClient {
    
    func media(position: PaginationPosition, accessToken: String) -> AnyPublisher<InstagramMediaCollection, ICError> {
        let url: URL = {
            switch position {
            case .start:
                return AppConstants.instagramGraphURL
                    .appendingPathComponent("me/media")
                    .appending(queryItems: mediaQueryItems(accessToken: accessToken, limit: Constants.mediaPageLimit))
            case .page(let url):
                return url
            }
        }()
        
        return httpClient.get(url: url, parameters: [:])
            .mapError { ICError.failedMediaRequest($0) }
            .flatMap { [weak self] data -> AnyPublisher<InstagramMediaCollection, ICError> in
                guard let self = self else { return Fail(error: ICError.internalError).eraseToAnyPublisher() }
                
                if let response: FacebookDataResponse<InstagramMedia> = data.extractObject(decoder: JSONDecoder.facebook) {
                    return self.process(mediaResponse: response, accessToken: accessToken)
                } else if let error: FacebookErrorResponse<InstagramMediaError> = data.extractObject(decoder: JSONDecoder.facebook) {
                    if error.error.isOAuthException {
                        return self.execute(mode: .authorization) { token in
                            return self.media(position: position, accessToken: token)
                        }
                    } else {
                        return Fail(error: ICError.failedMedia(error.error)).eraseToAnyPublisher()
                    }
                } else {
                    return Fail(error: ICError.noDataAvailable).eraseToAnyPublisher()
                }
        }.eraseToAnyPublisher()
    }
    
    func children(mediaId: String, accessToken: String) -> AnyPublisher<[InstagramMediaItem], ICError> {
        let url = AppConstants.instagramGraphURL
            .appendingPathComponent("\(mediaId)/children")
            .appending(queryItems: mediaQueryItems(accessToken: accessToken, limit: Constants.childrenPageLimit))
        
        return httpClient.get(url: url, parameters: [:])
            .tryMap { try $0.handleChildrenMediaResponse() }
            .mapError { ICError.failedMediaRequest($0) }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Utilities

private extension InstagramClient {
    
    func mediaQueryItems(accessToken: String, limit: Int) -> [URLQueryItem] {
        return [URLQueryItem(name: "access_token", value: accessToken),
                URLQueryItem(name: "fields", value: InstagramMedia.fields),
                URLQueryItem(name: "limit", value: "\(limit)")]
    }
    
    private func execute<T>(mode: RequestExecutionMode,
                            request: @escaping (String) -> AnyPublisher<T, ICError>) -> AnyPublisher<T, ICError> {
        switch mode {
        case .token(let token):
            return request(token)
        case .authorization:
            return authenticator.authenticate()
                .flatMap { token in request(token) }
                .eraseToAnyPublisher()
        }
    }
    
    func process(mediaResponse: FacebookDataResponse<InstagramMedia>,
                 accessToken: String) -> AnyPublisher<InstagramMediaCollection, ICError> {
        let itemsRequests: [AnyPublisher<[InstagramMediaItem], ICError>] = mediaResponse.data.compactMap { media in
            switch media.mediaType {
            case .image:
                return Just([InstagramMediaItem(media: media)])
                    .setFailureType(to: ICError.self)
                    .eraseToAnyPublisher()
            case .album:
                return children(mediaId: media.id, accessToken: accessToken)
            case .video:
                return nil
            }
        }
        
        return Publishers.MergeMany(itemsRequests)
            .collect()
            .map {
                let items = $0
                    .flatMap { $0 }
                    .sorted(by: >)
                
                let next = mediaResponse.paging?.next
                
                return InstagramMediaCollection(items: items, next: next)
        }.eraseToAnyPublisher()
    }
    
}

private extension Data {
    
    func handleChildrenMediaResponse() throws -> [InstagramMediaItem] {
        if let response: FacebookDataResponse<InstagramMedia> = extractObject(decoder: JSONDecoder.facebook) {
            return response.data
                .filter { $0.mediaType == .image }
                .map { InstagramMediaItem(media: $0) }
        } else if let error: FacebookErrorResponse<InstagramMediaError> = extractObject(decoder: JSONDecoder.facebook) {
            throw ICError.failedMedia(error.error)
        } else {
            throw ICError.noDataAvailable
        }
    }
    
}
