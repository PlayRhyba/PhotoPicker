//
//  DependencyManager.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 10.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class DependencyManager {
    
    static let sharedContainer: Container = {
        Container.loggingFunction = nil
        
        let container = SwinjectStoryboard.defaultContainer
        
        let assemblies: [Assembly] = [
            CoreAssembly(),
            InstagramAssembly(),
            ImagePickerAssembly(),
            ImageScreenAssembly()
        ]
        
        _ = Assembler(assemblies, container: container)
        
        return container
    }()
    
}
