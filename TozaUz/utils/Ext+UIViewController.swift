//
//  Ext+UIViewController.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 30/06/24.
//

import UIKit

extension UIViewController {
    func goLoginPage() {
        let newRootViewController = LanguageViewController()
        if let sceneDelegate = SceneDelegate.shared {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: newRootViewController)
        }
    }
}
