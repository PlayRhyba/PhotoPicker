//
//  InstagramAssembly.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

final class InstagramAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(InstagramLoginManagerProtocol.self) { _ in InstagramLoginManager() }
            .inObjectScope(.weak)
        
        container.autoregister(InstagramAuthenticatorProtocol.self, initializer: InstagramAuthenticator.init)
            .inObjectScope(.weak)
        
        container.autoregister(InstagramClientProtocol.self, initializer: InstagramClient.init)
            .inObjectScope(.container)
    }
    
}
