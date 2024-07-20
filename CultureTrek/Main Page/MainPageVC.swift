import UIKit

class MainPageVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Search Variables
    var isSearchExpanded = false
    var searchResults = [String]()
    
    var viewModel = MainPageViewModel()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "181A20")
        
        navigationItem.hidesBackButton = true
        
        configureTitle1()
        configureSearchIcon()
        configureSearchBar()
        configureScrollView()
        configurePageControl()
        configureTableView()
        viewModel.fetchMuseums()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Variables
    var title1: UILabel = {
        var title1 = UILabel()
        title1.text = "Museums"
        title1.textColor = .white
        title1.font = UIFont(name: "FiraCode-Regular", size: 35)
        return title1
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
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: Scrolling Pages Set up
    private let scrollView = UIScrollView()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.backgroundColor = .clear
        return pageControl
    }()
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.layer.cornerRadius = 15.0
        view.addSubview(scrollView)
    }
    
    func configurePageControl() {
        pageControl.addTarget(self,
                              action: #selector(pageControlDidChange(_:)),
                              for: .valueChanged)
        view.addSubview(pageControl)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * scrollView.frame.size.width, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 170, width: view.frame.size.width - 30, height: 50)
        scrollView.frame = CGRect(x: 15, y: 140, width: view.frame.size.width - 30, height: view.frame.size.height - 250)
        
        if scrollView.subviews.count == 0 {
            configureScrollViewContent()
        }
        
        tableView.frame = CGRect(x: 0, y: searchBar.frame.maxY + 10, width: view.frame.size.width, height: view.frame.size.height - searchBar.frame.maxY - 10)
    }
    
    private func configureScrollViewContent() {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 5, height: scrollView.frame.size.height)
        let backgrounds: [String] = ["louvre", "british", "national", "uffizi", "acropolis"]
        let names: [String] = ["the louvre", "the british museum", "the national gallery", "uffizi galleries", "acropolis museum"]
        
        for x in 0..<5 {
            let page = UIView(frame: CGRect(x: CGFloat(x) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            scrollView.addSubview(page)
            
            
            
            let imageView = UIImageView(image: UIImage(named: backgrounds[x]))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            page.addSubview(imageView)
            
            let nameLabel: UILabel = {
                let nameLabel = UILabel()
                nameLabel.text = names[x]
                nameLabel.textColor = .white
                nameLabel.numberOfLines = 0
                nameLabel.font = UIFont(name: "FiraCode-Regular", size: 32)
                return nameLabel
            }()
            
            page.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                nameLabel.topAnchor.constraint(equalTo: page.topAnchor, constant: 473),
                nameLabel.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 12),
                nameLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: page.trailingAnchor, multiplier: 20)
            ])
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: page.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: page.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: page.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: page.bottomAnchor)
            ])
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pageTapped(_:)))
            page.addGestureRecognizer(tapGestureRecognizer)
            page.isUserInteractionEnabled = true
            page.tag = x         }
    }
    
    @objc private func pageTapped(_ sender: UITapGestureRecognizer) {
        if let page = sender.view {
            let selectedMuseum = ["the louvre", "the british museum", "the national gallery", "uffizi galleries", "acropolis museum"][page.tag]
            let artifactsViewController = ArtifactsViewController()
            artifactsViewController.museumNameRecieved = selectedMuseum
            navigationController?.pushViewController(artifactsViewController, animated: true)
        }
    }
    
    // MARK: Configure UI Functions
    func configureTitle1() {
        view.addSubview(title1)
        title1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title1.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            title1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            title1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -210)
        ])
    }
    
    func configureSearchIcon() {
        view.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 82),
            searchIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 329),
            searchIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            searchIcon.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // Add tap gesture recognizer
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
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            self.title1.isHidden = true
            self.scrollView.isHidden = true
            self.pageControl.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func collapseSearchBar() {
        UIView.animate(withDuration: 0.3) {
            self.searchIcon.isHidden = false
            self.searchBar.alpha = 0
            self.title1.isHidden = false
            self.scrollView.isHidden = false
            self.pageControl.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    @objc func viewTapped() {
        UIView.animate(withDuration: 0.3){
            self.searchIcon.isHidden = false
            self.searchBar.alpha = 0
            self.title1.isHidden = false
            self.scrollView.isHidden = false
            self.pageControl.isHidden = false
            self.tableView.isHidden = true
        }
        self.view.endEditing(true)
    }
    // MARK: UIGestureRecognizerDelegate Method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: tableView) {
            return false
        }
        return true
    }
}

extension MainPageVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView : UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        if scrollView.isHidden{
            pageControl.currentPage = Int(pageIndex) + 1
        } else {
            pageControl.currentPage = Int(pageIndex)
        }
    }
}

// MARK: TableView Methods
extension MainPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(hex: "242424")
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMuseum = searchResults[indexPath.row]
        let artifactsViewController = ArtifactsViewController()
        artifactsViewController.museumNameRecieved = selectedMuseum
        navigationController?.pushViewController(artifactsViewController, animated: true)
    }
}
// MARK: Search Bar Text Changed
extension MainPageVC {
    @objc func searchBarTextChanged() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchResults = []
            tableView.reloadData()
            return
        }
        searchResults = viewModel.museums.map { $0.name }.filter { $0.localizedCaseInsensitiveContains(searchText) }
        tableView.reloadData()
    }
}
