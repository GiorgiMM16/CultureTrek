//
//  CustomTabBarController.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/12/24.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()

        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBar.appearance().tintColor = .white // Selected item color
        UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "A9A9A9")
    }

    // MARK: TabBar Set Up
    private func setUpTabBar() {
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")

        let museumsVC = MainPageVC()
        museumsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "building.columns")?.resized(to: CGSize(width: 45, height: 45)), tag: 0)
        museumsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let citiesVC = CityListPageVC()
        citiesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "building.2")?.resized(to: CGSize(width: 45, height: 45)), tag: 1)
        citiesVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let profileVC = ProfilePageVC()
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.crop.circle")?.resized(to: CGSize(width: 45, height: 45)), tag: 2)
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        self.viewControllers = [museumsVC, citiesVC, profileVC]
        self.selectedIndex = 0
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -5, right: 0)
        }
    }
}


// MARK: For icon image resizing
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

#Preview{
    CustomTabBarController()
}
