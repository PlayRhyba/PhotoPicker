//
//  SceneDelegate.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit
import SwinjectStoryboard

final class SceneDelegate: UIResponder {
    
    var window: UIWindow?
    
}

// MARK: - UIWindowSceneDelegate

extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(scene: scene)
    }
    
}

// MARK: - Private

private extension SceneDelegate {
    
    func setupWindow(scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let storyboard = SwinjectStoryboard.create(name: "Main",
                                                   bundle: nil,
                                                   container: DependencyManager.sharedContainer)
        
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
}
