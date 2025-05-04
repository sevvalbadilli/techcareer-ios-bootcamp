//
//  MainTabBarController.swift
//  iOSBootcamp-FinalProject
//
//  Created by ŞEVVAL on 30.04.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
    
        let anasayfaVC = AnasayfaViewController()
        anasayfaVC.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), tag: 0)
      
        let sepetVC = SepetViewController()
        sepetVC.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "cart"), tag: 2)

        let favorilerVC = FavorilerViewController()
        favorilerVC.view.backgroundColor = .systemGroupedBackground
        favorilerVC.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "heart"), tag: 1)

        viewControllers = [
            UINavigationController(rootViewController: anasayfaVC),
            UINavigationController(rootViewController: favorilerVC),
            UINavigationController(rootViewController: sepetVC)
        ]
    }

}

