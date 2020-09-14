//
//  URL+AppendingQueryItem.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

extension URL {
    
    func appending(queryItems: [URLQueryItem]) -> URL {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        
        var queryDictionary: [String: String] = [:]
        
        if let queryItems = components.queryItems {
            for item in queryItems {
                queryDictionary[item.name] = item.value
            }
        }
        
        for item in queryItems {
            queryDictionary[item.name] = item.value
        }
        
        var newComponents = components
        
        newComponents.queryItems = queryDictionary
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return newComponents.url ?? self
    }
    
    func queryItemValue(for name: String) -> String? {
        let queryItems = URLComponents(string: absoluteString)?.queryItems
        
        return queryItems?.first(where: { $0.name == name })?.value
    }
    
}
