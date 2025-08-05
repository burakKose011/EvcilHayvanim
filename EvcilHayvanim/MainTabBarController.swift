//
//  MainTabBarController.swift
//  EvcilHayvanim
//
//  Created by macbook on 5.08.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupViewControllers() {
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let petListVC = PetListViewController()
        let petListNav = UINavigationController(rootViewController: petListVC)
        petListNav.tabBarItem = UITabBarItem(
            title: "Evcil Hayvanlar",
            image: UIImage(systemName: "pawprint"),
            selectedImage: UIImage(systemName: "pawprint.fill")
        )
        
        let healthRecordsVC = HealthRecordsViewController()
        let healthRecordsNav = UINavigationController(rootViewController: healthRecordsVC)
        healthRecordsNav.tabBarItem = UITabBarItem(
            title: "Sağlık",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let appointmentsVC = AppointmentsViewController()
        let appointmentsNav = UINavigationController(rootViewController: appointmentsVC)
        appointmentsNav.tabBarItem = UITabBarItem(
            title: "Randevular",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.fill")
        )
        
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Ayarlar",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear.fill")
        )
        
        viewControllers = [
            dashboardNav,
            petListNav,
            healthRecordsNav,
            appointmentsNav,
            settingsNav
        ]
    }
} 
