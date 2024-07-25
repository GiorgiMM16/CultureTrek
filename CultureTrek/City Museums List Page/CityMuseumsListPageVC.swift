import UIKit

class CityMuseumsListPageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Variables and ViewModel
    var cityName: String?
    var cityImageURL: String?
    private let viewModel = CityMuseumsListPageVM()
    
    // MARK: - UI Components
    private lazy var cityNameTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "FiraCode-Regular", size: 35)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15.0
        return imageView
    }()
    
    private lazy var featuredMuseumsTitle: UILabel = {
        let label = UILabel()
        label.text = "Featured Museums"
        label.font = UIFont(name: "FiraCode-Regular", size: 30)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var museumsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MuseumTableViewCell.self, forCellReuseIdentifier: "MuseumCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var noMuseumsLabel: UILabel = {
        let label = UILabel()
        label.text = "No museums found"
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "181A20")
        setupUI()
        setupNavigationBar()
        fetchMuseums()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(cityNameTitle)
        view.addSubview(cityImageView)
        view.addSubview(featuredMuseumsTitle)
        view.addSubview(museumsTableView)
        view.addSubview(noMuseumsLabel)
        
        configureCityName()
        configureCityImageView()
        configureFeaturedMuseumsTitle()
        configureMuseumsTableView()
        configureNoMuseumsLabel()
    }
    
    private func configureCityName() {
        cityNameTitle.text = cityName
        cityNameTitle.textAlignment = .left
        cityNameTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityNameTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            cityNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            cityNameTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180)
        ])
    }
    
    private func configureCityImageView() {
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: cityNameTitle.bottomAnchor, constant: 25),
            cityImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        if let urlString = cityImageURL, let url = URL(string: urlString) {
            cityImageView.loadImage(from: url)
        }
    }
    
    private func configureFeaturedMuseumsTitle() {
        featuredMuseumsTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featuredMuseumsTitle.topAnchor.constraint(equalTo: cityImageView.bottomAnchor, constant: 35),
            featuredMuseumsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45)
        ])
    }
    
    private func configureMuseumsTableView() {
        museumsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            museumsTableView.topAnchor.constraint(equalTo: featuredMuseumsTitle.bottomAnchor, constant: 20),
            museumsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            museumsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            museumsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNoMuseumsLabel() {
        noMuseumsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noMuseumsLabel.centerXAnchor.constraint(equalTo: museumsTableView.centerXAnchor),
            noMuseumsLabel.centerYAnchor.constraint(equalTo: museumsTableView.centerYAnchor)
        ])
    }
    
    // MARK: - Nav Bar Setup
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Data Fetching
    private func fetchMuseums() {
        guard let cityName = cityName else { return }
        
        viewModel.fetchMuseums(for: cityName)
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.museumNames.isEmpty ?? true {
                    self?.noMuseumsLabel.isHidden = false
                    self?.museumsTableView.isHidden = true
                } else {
                    self?.noMuseumsLabel.isHidden = true
                    self?.museumsTableView.isHidden = false
                    self?.museumsTableView.reloadData()
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                print("Error fetching museums: \(error.localizedDescription)")
                self?.noMuseumsLabel.isHidden = false
                self?.museumsTableView.isHidden = true
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.museumNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuseumCell", for: indexPath) as! MuseumTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.museumNameLabel.text = viewModel.museumNames[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let museumName = viewModel.museumNames[indexPath.row]
        let artifactsVC = ArtifactsViewController()
        artifactsVC.museumNameReceived = museumName
        navigationController?.pushViewController(artifactsVC, animated: true)
    }
}

#Preview {
    CityMuseumsListPageVC()
}
