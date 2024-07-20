//
//  ProfilePageVC.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/20/24.
//

import UIKit

class ProfilePageVC: UIViewController {

    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: UI Variables
    
    var profilesTitle: UILabel = {
        var profilesTitle = UILabel()
        profilesTitle.text = "Profile"
        profilesTitle.textColor = .white
        profilesTitle.font = UIFont(name: "FiraCode-Regular", size: 35)
        return profilesTitle
    }()
    
    var profileImage: UIImageView = {
        var profileImage = UIImageView(image: UIImage(named: "profile"))
        return profileImage
    }()
    
    var profileName: UILabel = {
        var profileName = UILabel()
        profileName.text = "giorgi@gmail.com"
        profileName.textColor = .white
        profileName.font = UIFont(name: "FiraCode-Regular", size: 20)
        return profileName
    }()
    
    var signOutButton: UIButton = {
        var signOutButton = UIButton()
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.titleLabel?.font = UIFont(name: "FiraCode-Regular", size: 12)
        signOutButton.titleLabel?.textColor = .white
        signOutButton.layer.cornerRadius = 15.0
        signOutButton.backgroundColor = UIColor(hex: "353A40")
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        return signOutButton
    }()

    
    var thankYouLabel: UIImageView = {
        var thankYouLabel = UIImageView(image: UIImage(named: "thankyou"))
        return thankYouLabel
    }()
    
    // MARK: UI Functions
    func setUpUI() {
        view.backgroundColor = UIColor(hex: "181A20")
        configureProfilesTitle()
        configureProfileImage()
        configureProfileName()
        configureSignOutButton()
        configureThankYouLabel()
    }
    
    func configureProfilesTitle() {
        view.addSubview(profilesTitle)
        profilesTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilesTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            profilesTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            profilesTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
    }
    
    func configureProfileImage() {
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: profilesTitle.bottomAnchor, constant: 25),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -333)
        ])
    }
    
    func configureProfileName() {
        view.addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: profilesTitle.bottomAnchor, constant: 25),
            profileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 25),
            profileName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110)
        ])
    }
    
    func configureSignOutButton() {
        view.addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: profilesTitle.bottomAnchor, constant: 25),
            signOutButton.leadingAnchor.constraint(equalTo: profileName.trailingAnchor, constant: 25),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signOutButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configureThankYouLabel() {
        view.addSubview(thankYouLabel)
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
            thankYouLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }
    
    @objc func signOutButtonTapped() {
        let welcomePageVC = WelcomePageVC()
        navigationController?.pushViewController(welcomePageVC, animated: true)
        welcomePageVC.navigationItem.hidesBackButton = true
    }


}
