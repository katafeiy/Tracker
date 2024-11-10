import UIKit

final class TrackerViewController: UIViewController {
    
    var categories: [TrackerCategory]?
    var completed: [TrackerRecord]?
    
    private lazy var dateTracker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlackDay
        let localeID = Locale.preferredLanguages.first ?? "ru_RU"
        datePicker.locale = Locale(identifier: localeID)
        datePicker.addTarget(self, action: #selector(setDateTracker), for: .valueChanged)
        return datePicker
    }()
    
    let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.star
        return imageView
    }()
    
    let whatSearch: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var searchViewController: UISearchController = {
        let searchViewController = UISearchController()
        searchViewController.searchBar.placeholder = "Поиск"
        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.hidesNavigationBarDuringPresentation = false
        searchViewController.searchBar.tintColor = .ypBlackDay
        
        searchViewController.searchBar.delegate = self
        searchViewController.delegate = self
        
        return searchViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        configurationNavigationBar()
    }
    
    func configurationNavigationBar() {
        
        let leftButton = UIBarButtonItem(image: UIImage.plusButton, style: .done, target: self, action: #selector(setNewTracker))
        leftButton.tintColor = .ypBlackDay
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem()
        rightButton.customView = dateTracker
        self.navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchViewController
    }
    
    func configurationView() {
        
        view.backgroundColor = .ypWhiteDay
        dateTracker.center = view.center
        
        [starImage, whatSearch].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            whatSearch.heightAnchor.constraint(equalToConstant: 18),
            whatSearch.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            whatSearch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatSearch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func setDateTracker() {
        view.endEditing(true)
    }
    
    @objc func setNewTracker() {
        
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    public func dateString(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
}

extension TrackerViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
