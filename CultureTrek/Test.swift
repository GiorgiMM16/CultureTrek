import UIKit

class CityCity: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    private let viewModel = CityListPageVM()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var isSearchExpanded = false
    var searchResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureSearchBar()
        configureTableView1()
        setupTableView()
        setupViewModel()
        
        // Fetch cities
        viewModel.fetchEuropeanCities(maxRows: "20")
    }
    
    // MARK: Variables
    
    var cityTitle: UILabel = {
        var cityTitle = UILabel()
        cityTitle.text = "Cities"
        cityTitle.font = UIFont(name: "FiraCode-Regular", size: 35)
        cityTitle.textColor = .white
        return cityTitle
    }()
    
    var searchIcon: UIImageView = {
        var searchIcon = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .white
        return searchIcon
    }()
    
    var searchBar: UITextField = {
        var searchBar = UITextField()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .gray
        searchBar.layer.cornerRadius = 12.0
        searchBar.alpha = 0
        searchBar.textColor = .black
        searchBar.clearButtonMode = .whileEditing
        searchBar.addTarget(self, action: #selector(searchBarTextChanged), for: .editingChanged)
        return searchBar
    }()
    
    var tableView1: UITableView = {
        var tableView1 = UITableView()
        tableView1.isHidden = true
        tableView1.backgroundColor = .clear
        return tableView1
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView1.frame = CGRect(x: 0, y: searchBar.frame.maxY + 10, width: view.frame.size.width, height: view.frame.size.height - searchBar.frame.maxY - 10)
    }
    
    // MARK: UI Functions
    
    func setUpUI() {
        setUpCityTitle()
        configureSearchIcon()
        setupTableView()
        setupActivityIndicator()
        view.backgroundColor = UIColor(hex: "181A20")
        
        // Add tap gesture to dismiss search bar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func setUpCityTitle() {
        view.addSubview(cityTitle)
        cityTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            cityTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19)
        ])
    }
    
    func configureSearchIcon() {
        view.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 82),
            searchIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            searchIcon.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped))
        searchIcon.addGestureRecognizer(tapGesture)
        searchIcon.isUserInteractionEnabled = true
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 82),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTableView1() {
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView1.translatesAutoresizingMaskIntoConstraints = false
        tableView1.backgroundColor = .clear
        view.addSubview(tableView1)
    }
    
    @objc func searchIconTapped() {
        isSearchExpanded.toggle()
        
        if isSearchExpanded {
            expandSearchBar()
        } else {
            collapseSearchBar()
        }
    }
    
    func expandSearchBar() {
        UIView.animate(withDuration: 0.3) {
            self.searchIcon.isHidden = true
            self.searchBar.alpha = 1
            self.cityTitle.isHidden = true
            self.tableView.isHidden = true
            self.tableView1.isHidden = false
        }
    }
    
    func collapseSearchBar() {
        UIView.animate(withDuration: 0.3) {
            self.searchIcon.isHidden = false
            self.searchBar.alpha = 0
            self.cityTitle.isHidden = false
            self.tableView.isHidden = false
            self.tableView1.isHidden = true
        }
    }
    
    @objc func viewTapped() {
        UIView.animate(withDuration: 0.3) {
            self.searchIcon.isHidden = false
            self.searchBar.alpha = 0
            self.cityTitle.isHidden = false
            self.tableView.isHidden = false
            self.tableView1.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: tableView) || view.isDescendant(of: tableView1) {
            return false
        }
        return true
    }
    
    // MARK: TableView Setup
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(hex: "181A20")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cityTitle.bottomAnchor, constant: 18),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        tableView.rowHeight = 180
    }
    
    // MARK: Activity Indicator Setup
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onCitiesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        activityIndicator.startAnimating()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        let city = viewModel.cities[indexPath.section]
        cell.configure(with: city.imageUrl, cityName: city.name, countryName: city.countryName)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.cities[indexPath.section]
        let cityMuseumsVC = CityMuseumsListPageVC()
        cityMuseumsVC.cityName = city.name
        cityMuseumsVC.cityImageURL = city.imageUrl
        navigationController?.pushViewController(cityMuseumsVC, animated: true)
    }
    
    // MARK: Second TableView
    
    func tableView1(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView1(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView1.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    @objc func searchBarTextChanged(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if searchText.isEmpty {
            searchResults = viewModel.cities.map { $0.name }
        } else {
            searchResults = viewModel.cities.filter { $0.name.lowercased().contains(searchText.lowercased()) }.map { $0.name }
        }
        tableView1.reloadData()
    }
}
