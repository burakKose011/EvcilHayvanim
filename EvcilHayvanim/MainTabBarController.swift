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
        setupTabBarAppearance()
    }
    
    private func setupTabBar() {
        // Modern tab bar styling
        tabBar.tintColor = DesignSystem.Colors.primary
        tabBar.unselectedItemTintColor = DesignSystem.Colors.textSecondary
        tabBar.backgroundColor = DesignSystem.Colors.cardBackground
        
        // Better shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowRadius = 4
        
        // Prevent text changes
        tabBar.itemPositioning = .automatic
        tabBar.itemWidth = 0
        tabBar.itemSpacing = 0
    }
    
    private func setupTabBarAppearance() {
        // iOS 15+ appearance
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = DesignSystem.Colors.cardBackground
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: DesignSystem.Colors.textSecondary,
                .font: UIFont.systemFont(ofSize: 10, weight: .medium)
            ]
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: DesignSystem.Colors.primary,
                .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
            ]
            
            appearance.shadowColor = UIColor.clear
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "house.circle"),
            selectedImage: UIImage(systemName: "house.circle.fill")
        )
        dashboardNav.tabBarItem.tag = 0
        
        let petListVC = PetListViewController()
        let petListNav = UINavigationController(rootViewController: petListVC)
        petListNav.tabBarItem = UITabBarItem(
            title: "Dostlarım",
            image: UIImage(systemName: "pawprint.circle"),
            selectedImage: UIImage(systemName: "pawprint.circle.fill")
        )
        petListNav.tabBarItem.tag = 1
        
        let healthRecordsVC = HealthRecordsViewController()
        let healthRecordsNav = UINavigationController(rootViewController: healthRecordsVC)
        healthRecordsNav.tabBarItem = UITabBarItem(
            title: "Sağlık",
            image: UIImage(systemName: "heart.circle"),
            selectedImage: UIImage(systemName: "heart.circle.fill")
        )
        healthRecordsNav.tabBarItem.tag = 2
        
        let appointmentsVC = AppointmentsViewController()
        let appointmentsNav = UINavigationController(rootViewController: appointmentsVC)
        appointmentsNav.tabBarItem = UITabBarItem(
            title: "Randevular",
            image: UIImage(systemName: "calendar.circle"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )
        appointmentsNav.tabBarItem.tag = 3
        
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Ayarlar",
            image: UIImage(systemName: "gearshape.circle"),
            selectedImage: UIImage(systemName: "gearshape.circle.fill")
        )
        settingsNav.tabBarItem.tag = 4
        
        viewControllers = [
            dashboardNav,
            petListNav,
            healthRecordsNav,
            appointmentsNav,
            settingsNav
        ]
        
        // Force stable titles
        DispatchQueue.main.async {
            self.setupStableTitles()
        }
    }
    
    private func setupStableTitles() {
        guard let viewControllers = viewControllers else { return }
        
        let titles = ["Ana Sayfa", "Dostlarım", "Sağlık", "Randevular", "Ayarlar"]
        
        for (index, vc) in viewControllers.enumerated() {
            if index < titles.count {
                vc.tabBarItem.title = titles[index]
                vc.tabBarItem.tag = index
            }
        }
    }
} 
