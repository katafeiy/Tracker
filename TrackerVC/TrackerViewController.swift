import UIKit

final class TrackerViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var visibleCategories: [TrackerCategory] = []
    
    var currentDate: Date? {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        return dateFormatter.date(from: formattedDate) ?? Date()
    }
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return collectionView
        
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlackDay
        let localeID = Locale.preferredLanguages.first ?? "ru_RU"
        datePicker.locale = Locale(identifier: localeID)
        datePicker.addTarget(self, action: #selector(setDatePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.star
        return imageView
    }()
    
    private lazy var whatSearch: UILabel = {
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
        collectionView.dataSource = self
        collectionView.delegate = self
        updateVisibleData()
    }
    
    func configurationNavigationBar() {
        
        let leftButton = UIBarButtonItem(image: UIImage.plusButton, style: .done, target: self, action: #selector(setNewTracker))
        leftButton.tintColor = .ypBlackDay
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem()
        rightButton.customView = datePicker
        self.navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchViewController
    }
    
    func configurationView() {
        
        view.backgroundColor = .ypWhiteDay
        datePicker.center = view.center
        
        [starImage, whatSearch, collectionView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            whatSearch.heightAnchor.constraint(equalToConstant: 18),
            whatSearch.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            whatSearch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatSearch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func setDatePickerValueChanged(_ sender: UIDatePicker) {
        
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        
        updateVisibleData()
        
        view.endEditing(true)
        
    }
    
    func updateVisibleData() {
        
        guard let currentDate, let dayOfWeek = DaysOfWeek(date: currentDate) else { return }
        
        visibleCategories = []
        
        categories.forEach {
            let trackers = $0.trackerArray.filter({$0.schedule.contains(dayOfWeek)})
            if !trackers.isEmpty {
                visibleCategories.append(.init(name: $0.name, trackerArray: trackers))
            }
        }
        starImage.isHidden = !visibleCategories.isEmpty
        whatSearch.isHidden = !visibleCategories.isEmpty
        collectionView.reloadData()
    }
    
    @objc func setNewTracker() {
        
        let createTracker = CreateTrackerViewController()
        createTracker.delegate = self
        let navigationController = UINavigationController(rootViewController: createTracker)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
        
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

extension TrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        
        if (currentDate ?? Date()) <= Date() {
            cell.blockTap(isEnabled: true)
        } else {
            cell.blockTap(isEnabled: false)
        }
    
        cell.configureCell(tracker: tracker) { [weak self, weak cell] in
            guard let self else { return }
            if completedTrackers.first(where:{$0.id == tracker.id && $0.date == self.currentDate}) == nil {
                completedTrackers.append(.init(id: tracker.id , date: currentDate ?? Date()))
                let count = completedTrackers.filter({$0.id == tracker.id}).count
                cell?.configCompletion(counter: count, isCompleted: true)
            } else {
                completedTrackers.removeAll(where:{$0.id == tracker.id && $0.date == self.currentDate})
                let count = completedTrackers.filter({$0.id == tracker.id}).count
                cell?.configCompletion(counter: count, isCompleted: false)
            } 
        }
        let count = completedTrackers.filter({$0.id == tracker.id}).count
        let completed = completedTrackers.first(where:{$0.id == tracker.id && $0.date == self.currentDate}) != nil
        cell.configCompletion(counter: count, isCompleted: completed)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
}

extension TrackerViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension TrackerViewController: ProtocolNewHabitViewControllerOutput{
    
    func didCreate(newTracker: Tracker, forCategory: String) {
        if let index = categories.firstIndex(where: {$0.name == forCategory}) {
            categories[index] = TrackerCategory(name: forCategory, trackerArray: categories[index].trackerArray + [newTracker])
        } else {
            categories.append(TrackerCategory(name: forCategory, trackerArray:[newTracker]))
        }
        updateVisibleData()
    }
    
    
    func didCreate(newTracker: Tracker) {
        
        categories.append(TrackerCategory(name: "Новый категория", trackerArray:[newTracker]))
        updateVisibleData()
        
    }
}

