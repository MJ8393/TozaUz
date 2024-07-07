//
//  File.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 30/06/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    private var shapeLayer: CAShapeLayer?
    
    let vc1 = HomeViewController()
    let vc2 = HistoryViewController()
    let vc3 = MapViewController()
    let vc4 = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true

        let nc1 = UINavigationController(rootViewController: vc1)
        let nc2 = UINavigationController(rootViewController: vc2)
        let nc3 = UINavigationController(rootViewController: vc3)
        let nc4 = UINavigationController(rootViewController: vc4)

        nc1.title = "main" .translate()
        nc2.title = "history_tran".translate()
        nc3.title = "map".translate()
        nc4.title = "profile".translate()
        
        nc1.tabBarItem.image = UIImage(systemName: "house.fill")
        if UIImage(systemName: "doc.badge.clock.fill") != nil {
            nc2.tabBarItem.image = UIImage(systemName: "doc.badge.clock.fill")
        } else {
            nc2.tabBarItem.image = UIImage(systemName: "clock.fill")
        }
        if UIImage(systemName: "mappin.and.ellipse.circle.fill") != nil {
            nc3.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse.circle.fill")
        } else {
            nc3.tabBarItem.image = UIImage(systemName: "map.circle")
        }
        nc4.tabBarItem.image = UIImage(systemName: "person.fill")
        tabBar.tintColor = AppColors.mainColor
        self.delegate = self
        setViewControllers([nc1, nc2, nc3, nc4], animated: true)
        
        getLocations()
        
        let deviceMode = Functions.getDeviceMode()
        if deviceMode == .light {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        } else if deviceMode == .dark {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.unselectedItemTintColor = UIColor.gray
        UITabBar.appearance().layer.borderColor = UIColor.black.cgColor
        UITabBar.appearance().layer.borderWidth = 1
        addTabBarShadowBG()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.clipsToBounds = false
    }
    
    func getLocations() {
    }
    
//    func getLocations() {
//        TozaAPI.shared.fetchBoxLocations { result in
//            switch result {
//            case .success(let boxLocations):
//                for location in boxLocations {
////                    if let coordinates = location.getCoordinates() {
////                        print("Name: \(location.name), Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
////                    } else {
////                        print("Invalid coordinates for \(location.name)")
////                    }
//                }
//            case .failure(let error):
//                print("Error fetching box locations: \(error)")
//            }
//        }
//    }

    private func addTabBarShadowBG() {
        // Remove old shape layer if it exists
        if let oldShapeLayer = self.shapeLayer {
            oldShapeLayer.removeFromSuperlayer()
        }
        
        // Create a blur effect
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert the blur effect view below the tab bar's items
        tabBar.insertSubview(blurEffectView, at: 0)
        
        // Create a shape layer for the custom shape
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.shouldRasterize = true
        shapeLayer.rasterizationScale = UIScreen.main.scale
        tabBar.layer.insertSublayer(shapeLayer, at: 1)
        
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 74
        let path = UIBezierPath()
        let centerWidth = tabBar.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height), y: 0))
        path.addLine(to: CGPoint(x: tabBar.frame.width, y: 0))
        path.addLine(to: CGPoint(x: tabBar.frame.width, y: tabBar.frame.height))
        path.addLine(to: CGPoint(x: 0, y: tabBar.frame.height))
        path.close()
        return path.cgPath
    }
    
    @objc func dismissRegisterViewController() {
        self.dismiss(animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tagValue = viewController.tabBarItem.tag
        if tagValue == 2 {
            return false
        }
        return true
    }
}

extension UINavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer?.isEnabled = true
            } else {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
}
