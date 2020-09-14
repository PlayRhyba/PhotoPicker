//
//  WebsiteDataManager.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import WebKit

protocol WebsiteDataManagerProtocol {
    
    func clearData()
    func clearInstagramData()
    
}

final class WebsiteDataManager {}

// MARK: - WebsiteDataManagerProtocol

extension WebsiteDataManager: WebsiteDataManagerProtocol {
    
    func clearData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        clearData(filter: { _ in true })
    }
    
    func clearInstagramData() {
        clearData(filter: {
            let displayName = $0.displayName.lowercased()
            
            return displayName.contains("instagram") ||
                displayName.contains("facebook") ||
                displayName.contains("fbcdn")
        })
    }
    
}

// MARK: - Private

private extension WebsiteDataManager {
    
    func clearData(filter: @escaping (WKWebsiteDataRecord) -> Bool) {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                if filter(record) {
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes,
                                                            for: [record],
                                                            completionHandler: {})
                }
            }
        }
    }
    
}
