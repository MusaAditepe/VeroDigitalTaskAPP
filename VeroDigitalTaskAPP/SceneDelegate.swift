//
//  SceneDelegate.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // CoreData'yı başlat
        _ = CoreDataManager.shared.persistentContainer
        
        let window = UIWindow(windowScene: windowScene)
        let viewController = TaskListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // CoreData değişikliklerini kaydet
        try? CoreDataManager.shared.context.save()
    }
}
