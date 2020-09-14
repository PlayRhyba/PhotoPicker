//
//  UserDataStorage.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Foundation

protocol UserDataStorageProtocol {
    
    func save(_ value: Any, forKey key: String)
    func deleteValue(forKey key: String)
    func value(forKey key: String) -> Any?
    
}

final class UserDataStorage: UserDataStorageProtocol {
    
    func save(_ value: Any, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func deleteValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
}
