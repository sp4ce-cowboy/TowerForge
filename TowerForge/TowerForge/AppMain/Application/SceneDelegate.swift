//
//  SceneDelegate.swift
//  TowerForge
//
//  Added for the App Store release (Nov 2026): iPadOS 27 requires the scene-based life cycle.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        window?.overrideUserInterfaceStyle = .light
    }

    /// Pauses a single-player game (or opens the menu in an online one) when the app
    /// stops being active, e.g. for a phone call or the app switcher.
    func sceneWillResignActive(_ scene: UIScene) {
        guard let navigationController = window?.rootViewController as? UINavigationController,
              let gameViewController = navigationController.topViewController as? GameViewController else {
            return
        }

        if gameViewController.roomId != nil {
            gameViewController.onMenu()
        } else {
            gameViewController.pause()
        }
    }
}
