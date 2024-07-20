//
//  WelcomePageVC.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/8/24.
//

import UIKit

class WelcomePageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    
    // MARK: Text Variables
    
    var mainHeadTitle1: UILabel = {
        var mainHeadTitle1 = UILabel()
        mainHeadTitle1.text = "Culture Trek"
        mainHeadTitle1.font = UIFont(name: "FrederickatheGreat-Regular", size: 80)
        return mainHeadTitle1
    }()
    
    var mainHeadTitle2: UILabel = {
        var mainHeadTitle2 = UILabel()
        mainHeadTitle2.text = "Welcomes you"
        mainHeadTitle2.font = UIFont(name: "FrederickatheGreat-Regular", size: 80)
        return mainHeadTitle2
    }()
    
    // MARK: Button Variables
    
    var logInButton: UIButton = {
        var logInButton = UIButton()
        logInButton.setTitle("Log In", for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "FiraCode-Regular", size: 18)
        logInButton.layer.cornerRadius = 18.0
        logInButton.backgroundColor = UIColor(hex: "353A40")
        logInButton.addTarget(self, action: #selector(showLogInPageView), for: .touchUpInside) // Ignored this Error (the edit it suggests disables functionality)
        return logInButton
    }()
    
    var registerButton: UIButton = {
        var registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.layer.cornerRadius = 18.0
        registerButton.backgroundColor = UIColor(hex: "353A40")
        registerButton.titleLabel?.font = UIFont(name: "FiraCode-Regular", size: 18)
        registerButton.addTarget(self, action: #selector(showRegisterPageView), for: .touchUpInside) // Ignored this Error (the edit it suggests disables functionality)
        return registerButton
    }()
    
    // MARK: Functions
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "181A20")
        configureMainHeadTitle1()
        configureMainHeadTitle2()
        configureLogInButton()
        configureRegisterButton()
    }
    
    func configureMainHeadTitle1() {
        view.addSubview(mainHeadTitle1)
        mainHeadTitle1.translatesAutoresizingMaskIntoConstraints = false
        mainHeadTitle1.numberOfLines = 0
        mainHeadTitle1.textColor = .white
        NSLayoutConstraint.activate([
            mainHeadTitle1.topAnchor.constraint(equalTo: view.topAnchor, constant: 81),
            mainHeadTitle1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainHeadTitle1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
    
    func configureMainHeadTitle2() {
        view.addSubview(mainHeadTitle2)
        mainHeadTitle2.translatesAutoresizingMaskIntoConstraints = false
        mainHeadTitle2.numberOfLines = 0
        mainHeadTitle2.textColor = .white
        mainHeadTitle2.textAlignment = .right
        NSLayoutConstraint.activate([
            mainHeadTitle2.topAnchor.constraint(equalTo: mainHeadTitle1.bottomAnchor, constant: 5),
            mainHeadTitle2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            mainHeadTitle2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }
    
    func configureLogInButton(){
        view.addSubview(logInButton)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: mainHeadTitle2.bottomAnchor, constant: 74),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 129),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            logInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configureRegisterButton(){
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 26),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 129),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -174),
            registerButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: objc button functions
    
    @objc func showRegisterPageView() {
        let registerPageVC = RegisterPageVC()
        navigationController?.pushViewController(registerPageVC, animated: true)
    }
    
    @objc func showLogInPageView() {
        let logInPageVC = LogInPageVC()
        navigationController?.pushViewController(logInPageVC, animated: true)
    }

}
