import UIKit

final class TrackerViewController: UIViewController {
    
    private let viewModel: TrackerViewModel
    
    private lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.backgroundColor = .clear
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            TrackerCategoryNameCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader ,
            withReuseIdentifier: TrackerCategoryNameCell.headerIdentifier
        )
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
    
    private lazy var starImage: ImprovedUIImageView = {
        ImprovedUIImageView(image: .star)
    }()
    
    private lazy var whatSearch: ImprovedUILabel = {
        ImprovedUILabel(text: "Что будем отслеживать?",
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlackDay)
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
    
    init(viewModel: TrackerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configurationView()
        configurationNavigationBar()
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        bindingViewModel()
        viewModel.viewDidLoad()
    }
    
    func bindingViewModel() {
        viewModel.didUpdateVisibleData = { [weak self] in
            guard let self else { return }
            starImage.isHidden = !viewModel.visibleCategories.isEmpty
            whatSearch.isHidden = !viewModel.visibleCategories.isEmpty
            mainCollectionView.reloadData()
        }
    }
    
    private func configurationNavigationBar() {
        
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
    
    private func configurationView() {
        
        view.backgroundColor = .ypWhiteDay
        datePicker.center = view.center
        
        view.addSubviews(starImage, whatSearch, mainCollectionView)
        
        NSLayoutConstraint.activate([
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            whatSearch.heightAnchor.constraint(equalToConstant: 18),
            whatSearch.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            whatSearch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatSearch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func setDatePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.updateCurrentDate(sender.date)
        view.endEditing(true)
    }
    
    @objc private func setNewTracker() {
        let createTracker = CreateTrackerViewController(viewModel: CreateTrackerViewModel())
        createTracker.delegate = self
        let navigationController = UINavigationController(rootViewController: createTracker)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryNameCell.headerIdentifier,
            for: indexPath
        ) as?  TrackerCategoryNameCell else { return UICollectionReusableView() }
        
        let title = viewModel.visibleCategories[indexPath.section].name
        headerView.configure(with: title)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        let tracker = viewModel.visibleCategories[indexPath.section].trackerArray[indexPath.row]
        
        cell.blockTap(isEnabled: viewModel.isEnabledDate())
        
        cell.configureCell(tracker: tracker) { [weak self, weak cell] in
            guard let self else { return }
            let isCompleted = viewModel.toggleTracker(tracker)
            let count = viewModel.countTrackerExecution(tracker)
            cell?.configCompletion(counter: count, isCompleted: isCompleted)
        }
        
        let count = viewModel.countTrackerExecution(tracker)
        let isCompleted = viewModel.isTrackerExecuted(tracker)
        cell.configCompletion(counter: count, isCompleted: isCompleted)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard indexPaths.count > 0 else { return nil }
        let indexPaths = IndexPath(item: indexPaths[0].item, section: indexPaths[0].section)
        let tracker = viewModel.visibleCategories[indexPaths.section].trackerArray[indexPaths.row]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            
            return UIMenu(children: [
                UIAction(title: self.viewModel.isPinned(tracker) ? "Открепить" : "Закрепить", image: .pin.withTintColor(.ypBlackDay)) { [weak self] _ in
                    guard let self else { return }
                    self.attachTracker(indexPath: indexPaths)
                },
                
                UIAction(title: "Редактировать", image: .pencilAndListClipboard.withTintColor(.ypBlackDay)) { [weak self] _ in
                    guard let self else { return }
                    self.editTracker(indexPath: indexPaths)
                },
                
                UIAction(title: "Удалить", image: .trash.withTintColor(.ypRed), attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.deleteTracker(indexPath: indexPaths)
                }
            ])
        })
    }
    
    func attachTracker(indexPath: IndexPath) {
        let tracker = viewModel.visibleCategories[indexPath.section].trackerArray[indexPath.row]
        viewModel.updateAttachCategories(tracker)
    }
    
    func deleteTracker(indexPath: IndexPath) {
        let tracker = viewModel.visibleCategories[indexPath.section].trackerArray[indexPath.row]
        viewModel.updateDeleteTracker(tracker)
    }
    
    func editTracker(indexPath: IndexPath) {
        let tracker = viewModel.visibleCategories[indexPath.section].trackerArray[indexPath.row]
        viewModel.updateEditTracker(tracker)
    }
}

extension TrackerViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Функционал данного метода будет добавлен в 17 спринте)))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension TrackerViewController: ProtocolNewTrackerEventViewControllerOutput {
    
    func didCreate(newTracker: Tracker, forCategory: String) {
        viewModel.didCreateTracker(newTracker: newTracker, forCategory: forCategory)
    }
}
