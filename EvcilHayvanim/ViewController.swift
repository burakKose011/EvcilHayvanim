//
//  ViewController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainTabBar()
    }
    
    private func setupMainTabBar() {
        let mainTabBarController = MainTabBarController()
        
        // Present the tab bar controller
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: false)
    }
}

