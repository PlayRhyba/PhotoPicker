//
//  CoreAssembly.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Swinject

final class CoreAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HttpClientProtocol.self) { _ in HttpClient() }
            .inObjectScope(.container)
        
        container.register(UserDataStorageProtocol.self) { _ in UserDataStorage() }
            .inObjectScope(.container)
        
        container.register(WebsiteDataManagerProtocol.self) { _ in WebsiteDataManager() }
            .inObjectScope(.container)
        
        container.register(PermissionsManagable.self) { _ in PermissionsManager() }
            .inObjectScope(.container)
    }
    
}
