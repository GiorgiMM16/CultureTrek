import UIKit

class CityMuseumsListPageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: Variables and ViewModel
    @Published var cityName: String?
    var cityImageURL: String?
    let viewModel = CityMuseumsListPageVM()
    
    // MARK: UI Components
    
    lazy var cityNameTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "FiraCode-Regular", size: 35)
        label.textAlignment = .center
        return label
    }()
    
    lazy var cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var featuredMuseumsTitle: UILabel = {
        var featuredMuseumsTitle = UILabel()
        featuredMuseumsTitle.text = "Featured Museums"
        featuredMuseumsTitle.font = UIFont(name: "FiraCode-Regular", size: 30)
        featuredMuseumsTitle.textAlignment = .center
        featuredMuseumsTitle.textColor = .white
        return featuredMuseumsTitle
    }()
    
    lazy var museumsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MuseumTableViewCell.self, forCellReuseIdentifier: "MuseumCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var noMuseumsLabel: UILabel = {
        let label = UILabel()
        label.text = "No museums found"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "181A20")
        setupUI()
        setupNavigationBar()
        fetchMuseums()
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        configureCityName()
        configureCityImageView()
        configureFeaturedMuseumsTitls()
        configureMuseumsTableView()
        configureNoMuseumsLabel()
    }
    
    func configureCityName() {
        if let cityName = cityName {
            cityNameTitle.text = cityName
            cityNameTitle.textAlignment = .left
            view.addSubview(cityNameTitle)
            cityNameTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cityNameTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
                cityNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
                cityNameTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180)
            ])
        }
    }
    
    func configureCityImageView() {
        view.addSubview(cityImageView)
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        cityImageView.layer.cornerRadius = 15.0
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
    
    func configureFeaturedMuseumsTitls() {
        view.addSubview(featuredMuseumsTitle)
        featuredMuseumsTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featuredMuseumsTitle.topAnchor.constraint(equalTo: cityImageView.bottomAnchor, constant: 35),
            featuredMuseumsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45)
        ])
    }
    
    func configureMuseumsTableView() {
        view.addSubview(museumsTableView)
        museumsTableView.backgroundColor = .clear
        museumsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            museumsTableView.topAnchor.constraint(equalTo: featuredMuseumsTitle.bottomAnchor, constant: 20),
            museumsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            museumsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            museumsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNoMuseumsLabel() {
        view.addSubview(noMuseumsLabel)
        noMuseumsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noMuseumsLabel.centerXAnchor.constraint(equalTo: museumsTableView.centerXAnchor),
            noMuseumsLabel.centerYAnchor.constraint(equalTo: museumsTableView.centerYAnchor)
        ])
        
        noMuseumsLabel.isHidden = true
    }
    
    
    // MARK: Nav Bar Set Up
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Data Fetching
    
    private func fetchMuseums() {
        guard let cityName = cityName else { return }
        
        
        viewModel.fetchMuseums(for: cityName)
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.noMuseumsLabel.isHidden = true
                self?.museumsTableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                print("Error fetching museums: \(error.localizedDescription)")
                self?.noMuseumsLabel.isHidden = false
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
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
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let museumName = viewModel.museumNames[indexPath.row]
        let ArtifactVC = ArtifactsViewController()
        ArtifactVC.museumNameRecieved = museumName
        navigationController?.pushViewController(ArtifactVC, animated: true)
    }
}
