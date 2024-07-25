import UIKit

class CityListPageVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // MARK: Variables and ViewModel
    private let viewModel = CityListPageVM()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var isSearchExpanded = false
    var searchResults = [String]()
    
    // MARK: LifeCycle / Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView1.frame = CGRect(x: 0, y: searchBar.frame.maxY + 10, width: view.frame.size.width, height: view.frame.size.height - searchBar.frame.maxY - 10)
    }
    
    // MARK: UI Elements
    var cityTitle: UILabel = {
        let label = UILabel()
        label.text = "Cities"
        label.font = UIFont(name: "FiraCode-Regular", size: 35)
        label.textColor = .white
        return label
    }()
    
    var searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 12.0
        textField.alpha = 0
        textField.textColor = .black
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    var tableView1: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: UI Setup
    func setUpUI() {
        view.backgroundColor = UIColor(hex: "181A20")
        configureCityTitle()
        configureSearchIcon()
        setupActivityIndicator()
        configureSearchBar()
        configureTableView1()
        configureTableView()
        setupViewModel()
        viewModel.fetchEuropeanCities(maxRows: "20")
        configureTapGesture()
    }
    
    func configureCityTitle() {
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
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
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
        tableView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView1)
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
    
    // MARK: Gestures Configuration
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: tableView) || view.isDescendant(of: tableView1) {
            return false
        }
        return true
    }
    
    // MARK: objc Functions
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
    
    @objc func searchIconTapped() {
        isSearchExpanded.toggle()
        if isSearchExpanded {
            expandSearchBar()
        } else {
            collapseSearchBar()
        }
    }
    
    // MARK: TableView Setup
    private func configureTableView() {
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
    
    // MARK: ViewModel Set Up
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
    
    // MARK: TableView Delegate / DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == self.tableView ? viewModel.cities.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tableView ? 1 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            let city = viewModel.cities[indexPath.section]
            cell.configure(with: city.imageUrl, cityName: city.name, countryName: city.countryName)
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = searchResults[indexPath.row]
            cell.backgroundColor = .gray
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let selectedCity = viewModel.cities[indexPath.section]
            let cityDetailsVC = CityMuseumsListPageVC()
            cityDetailsVC.cityName = selectedCity.name
            cityDetailsVC.cityImageURL = selectedCity.imageUrl
            navigationController?.pushViewController(cityDetailsVC, animated: true)
        } else {
        }
    }
    
    // MARK: Search Bar Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let searchText = text.replacingCharacters(in: range, with: string)
            if searchText.isEmpty {
                searchResults.removeAll()
                tableView1.isHidden = true
            } else {
                searchResults = viewModel.cities.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }.map { $0.name }
                tableView1.isHidden = false
                tableView1.reloadData()
            }
        }
        return true
    }
}
