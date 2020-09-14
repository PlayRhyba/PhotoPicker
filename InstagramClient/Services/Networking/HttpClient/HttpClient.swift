//
//  HttpClient.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Alamofire
import Combine

protocol HttpClientProtocol {
    
    func post(url: URL, parameters: [String: String]) -> AnyPublisher<Data, Error>
    func get(url: URL, parameters: [String: String]) -> AnyPublisher<Data, Error>
    
}

final class HttpClient {}

// MARK: - HttpClientProtocol

extension HttpClient: HttpClientProtocol {
    
    func get(url: URL, parameters: [String: String]) -> AnyPublisher<Data, Error> {
        return requestData(method: .get, url: url, parameters: parameters)
    }
    
    func post(url: URL, parameters: [String: String]) -> AnyPublisher<Data, Error> {
        return requestData(method: .post, url: url, parameters: parameters)
    }
    
}

// MARK: - Private

private extension HttpClient {
    
    func requestData(method: HTTPMethod,
                     url: URL,
                     parameters: [String: String]) -> AnyPublisher<Data, Error> {
        return AF.request(url, method: method, parameters: parameters)
            .publishData()
            .tryMap { response in
                guard let value = response.value else {
                    throw response.error ?? ICError.noDataAvailable
                }
                
                return value
        }.eraseToAnyPublisher()
    }
    
}
