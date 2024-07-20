//
//  RegisterPageVC.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/12/24.
//

import UIKit
import SwiftUI
import Combine

class RegisterPageVC: UIViewController, RegisterViewPageDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = RegisterPageVM()
        viewModel.delegate = self
        
        let swiftUIView = RegisterPageView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        hostingController.view.frame = self.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    func navigateToMainPage() {
        let tabBar = CustomTabBarController()
        
        navigationController?.setViewControllers([tabBar], animated: true)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}


