//
//  ArtifactsVC.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 6/30/24.
//

import UIKit

class ArtifactsViewController: UIViewController {
    
    // MARK: Variables and ViewModel
    private let viewModel = ArtifactsViewModel()
    private var tableView: UITableView!
    var museumNameRecieved: String?
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: UI Components
    
    var title1: UILabel = {
        var title1 = UILabel()
        title1.textColor = .white
        title1.font = UIFont(name: "FiraCode-Regular", size: 35)
        title1.textAlignment = .left
        return title1
    }()
    
    var museumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15.0
        return imageView
    }()
    
    var featuredArtifactsTitle: UILabel = {
        var featuredArtifactsTitle = UILabel()
        featuredArtifactsTitle.text = "Featured Artifacts"
        featuredArtifactsTitle.font = UIFont(name: "FiraCode-Regular", size: 30)
        featuredArtifactsTitle.textAlignment = .left
        featuredArtifactsTitle.textColor = .white
        return featuredArtifactsTitle
    }()
    
    // MARK: UI Set Up
    
    func setUpUI() {
        view.backgroundColor = UIColor(hex: "181A20")
        //Data Fetching
        setupViewModel()
        viewModel.fetchArtifacts(for: museumNameRecieved ?? "Louvre")
        fetchMuseumPhoto()
        
        // UI Set Up
        configureTitle1()
        configureMuseumImageView()
        configureFeaturedMuseumsTitle()
        setupTableView()
        
        
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func configureTitle1() {
        view.addSubview(title1)
        title1.text = museumNameRecieved
        title1.numberOfLines = 0
        title1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title1.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            title1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            title1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
    
    func configureMuseumImageView() {
        view.addSubview(museumImageView)
        museumImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            museumImageView.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 25),
            museumImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            museumImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            museumImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func configureFeaturedMuseumsTitle() {
        view.addSubview(featuredArtifactsTitle)
        featuredArtifactsTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featuredArtifactsTitle.topAnchor.constraint(equalTo: museumImageView.bottomAnchor, constant: 35),
            featuredArtifactsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            featuredArtifactsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
    
    // MARK: TableView Set Up
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArtifactsTableViewCell.self, forCellReuseIdentifier: ArtifactsTableViewCell.identifier)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: featuredArtifactsTitle.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: ViewModel Set Up
    
    private func setupViewModel() {
        viewModel.onArtifactsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Fetch Museum Photo
    
    private func fetchMuseumPhoto() {
        guard let museumName = museumNameRecieved else { return }
        
        viewModel.fetchImageForAMuseum(museumName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageURLString):
                    self?.museumImageView.loadImage(from: URL(string: imageURLString))
                case .failure(let error):
                    print("Failed to fetch image: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ArtifactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artifacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtifactsTableViewCell.identifier, for: indexPath) as! ArtifactsTableViewCell
        let artifact = viewModel.artifacts[indexPath.row]
        cell.configure(with: artifact.title.last, imageURLString: artifact.edmIsShownBy?.last)
        return cell
    }
}

// MARK: - UIImageView Extension for Loading Images

extension UIImageView {
    func loadImage(from url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

extension ArtifactsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
