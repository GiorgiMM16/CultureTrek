import UIKit
import SwiftUI
import Combine

class LogInPageVC: UIViewController, LogInPageViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LogInViewModel()
        viewModel.delegate = self
        
        let swiftUIView = LogInPageView(viewModel: viewModel)
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
