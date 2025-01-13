import UIKit
import YandexMobileMetrica

final class TrackerViewController: UIViewController {
    
    private let viewModel: TrackerViewModel
    
    private var analyticsService = AnalyticsService()
    private var mainCollectionViewTopConstraint: NSLayoutConstraint?
    
    private lazy var pinnedView: PinnedCollectionView = {
        let pinnedView = PinnedCollectionView()
        pinnedView.backgroundColor = .clear
        pinnedView.delegate = self
        pinnedView.dataSource = self
        return pinnedView
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.bottom = 50
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
        datePicker.tintColor = .ypBlack
        let localeID = Locale.preferredLanguages.first ?? "ru_RU"
        datePicker.locale = Locale(identifier: localeID)
        datePicker.addTarget(self, action: #selector(setDatePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var starImage: ImprovedUIImageView = {
        ImprovedUIImageView(image: .star)
    }()
    
    private lazy var searchImage: ImprovedUIImageView = {
        ImprovedUIImageView(image: .searchingFace)
    }()
    
    private lazy var whatSearchLabel: ImprovedUILabel = {
        ImprovedUILabel(text: emptyStateText,
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlack)
    }()
    
    private lazy var nothingSearchLabel: ImprovedUILabel = {
        ImprovedUILabel(text: emptySearchText,
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlack)
    }()
    
    private lazy var searchViewController: UISearchController = {
        let searchViewController = UISearchController()
        searchViewController.searchBar.placeholder = placeholderForSearch
        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.hidesNavigationBarDuringPresentation = false
        searchViewController.searchBar.tintColor = .ypBlack
        searchViewController.searchBar.delegate = self
        searchViewController.delegate = self
        return searchViewController
    }()
    
    private lazy var filterButton: ImprovedUIButton = {
        let filterButton = ImprovedUIButton(title: .filter,
                                            titleColor: .ypWhite,
                                            backgroundColor: .ypBlue,
                                            cornerRadius: 16, fontSize: 17,
                                            fontWeight: .regular)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return filterButton
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
    
    var showSearchImage: Bool {
        let isSearchEmpty = viewModel.searchVisibleCategories.allSatisfy { $0.trackerArray.isEmpty }
        return isSearchEmpty && (viewModel.filterType != .allTrackers || !viewModel.searchVisibleCategories.isEmpty)
    }
    
    func bindingViewModel() {
        viewModel.didUpdateVisibleData = { [weak self] in
            guard let self else { return }
            
            starImage.isHidden = viewModel.visibleCategories.isEmpty || viewModel.searchVisibleCategories.isEmpty && viewModel.filterType == .allTrackers
            whatSearchLabel.isHidden = starImage.isHidden
            
            searchImage.isHidden = viewModel.visibleCategories.isEmpty || viewModel.searchVisibleCategories.isEmpty && viewModel.filterType == .allTrackers
            nothingSearchLabel.isHidden = searchImage.isHidden

            pinnedView.isHidden = viewModel.attachVisibleTracker.isEmpty
            filterButton.isHidden = viewModel.visibleCategories.isEmpty
                        
            self.mainCollectionViewTopConstraint?.isActive = false
            self.mainCollectionViewTopConstraint = self.mainCollectionView.topAnchor.constraint(
                equalTo: self.viewModel.attachVisibleTracker.isEmpty ?
                self.view.safeAreaLayoutGuide.topAnchor : self.pinnedView.bottomAnchor
            )
            self.mainCollectionViewTopConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            mainCollectionView.reloadData()
            pinnedView.reloadData()
        }
        
        viewModel.didUpdateTrackerStatus = { [weak self] in
            guard let self else { return }
            self.mainCollectionView.reloadData()
            self.pinnedView.reloadData()
        }
        
        viewModel.didUpdateSearching = { [weak self] in
            guard let self else { return }
            searchImage.isHidden = showSearchImage
            nothingSearchLabel.isHidden = searchImage.isHidden
            searchImage.isHidden = !(searchViewController.searchBar.text?.isEmpty == false && viewModel.searchVisibleCategories.isEmpty)
            nothingSearchLabel.isHidden = searchImage.isHidden
            mainCollectionView.reloadData()
        }
    }
    
    private func configurationNavigationBar() {
        
        let leftButton = UIBarButtonItem(image: UIImage.plusButton, style: .done, target: self, action: #selector(setNewTracker))
        leftButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem()
        rightButton.customView = datePicker
        self.navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.title = navigationItemTitleTVC
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchViewController
    }
    
    private func configurationView() {
        
        view.backgroundColor = .ypWhite
        datePicker.center = view.center
        
        view.addSubviews(starImage, searchImage, whatSearchLabel, nothingSearchLabel, mainCollectionView, pinnedView, filterButton)
        
        mainCollectionViewTopConstraint = mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        guard let mainCollectionViewTopConstraint else { return }
        
        NSLayoutConstraint.activate([
            
            pinnedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pinnedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pinnedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pinnedView.heightAnchor.constraint(equalToConstant: 178),
            
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            searchImage.heightAnchor.constraint(equalToConstant: 80),
            searchImage.widthAnchor.constraint(equalToConstant: 80),
            searchImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            searchImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            whatSearchLabel.heightAnchor.constraint(equalToConstant: 18),
            whatSearchLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            whatSearchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatSearchLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            nothingSearchLabel.heightAnchor.constraint(equalToConstant: 18),
            nothingSearchLabel.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 8),
            nothingSearchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nothingSearchLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            mainCollectionViewTopConstraint,
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 130),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -130),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func filterButtonTapped() {
        
        analyticsService.sendEvent(event: .click, screen: .click, item: .filter)
        
        let viewModel = FilterViewModel(initialFilterType: self.viewModel.filterType)
        let filterViewController = FilterViewController(viewModel: viewModel)
        
        viewModel.didSelectFilter = { [weak self] filterType in
            guard let self else { return }
            self.viewModel.updateFilterType(filterType)
        }
        
        let navigationController = UINavigationController(rootViewController: filterViewController)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
    
    @objc private func setDatePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.updateCurrentDate(sender.date)
        view.endEditing(true)
    }
    
    @objc private func setNewTracker() {
        
        analyticsService.sendEvent(event: .open, screen: .open)
        
        let createTracker = CreateTrackerViewController(viewModel: CreateTrackerViewModel())
        createTracker.delegate = self
        let navigationController = UINavigationController(rootViewController: createTracker)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView === pinnedView ? 1 : viewModel.searchVisibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView === pinnedView ? viewModel.attachVisibleTracker.count : viewModel.searchVisibleCategories[section].trackerArray.count
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
        
        let title = collectionView === pinnedView ? pinnedCategory : viewModel.searchVisibleCategories[indexPath.section].name
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
        
        let tracker = collectionView === pinnedView ? viewModel.attachVisibleTracker[indexPath.row] : viewModel.searchVisibleCategories[indexPath.section].trackerArray[indexPath.row]
        
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
        CGSize(width: (mainCollectionView.frame.width - 16 * 2 - 9) / 2  , height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard indexPaths.count > 0 else { return nil }
        let indexPaths = IndexPath(item: indexPaths[0].item, section: indexPaths[0].section)
        let tracker = collectionView === pinnedView ? viewModel.attachVisibleTracker[indexPaths.row] : viewModel.searchVisibleCategories[indexPaths.section].trackerArray[indexPaths.row]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            
            return UIMenu(children: [
                UIAction(title: self.viewModel.isPinned(tracker) ? menuTitleUnPinnedTVC : menuTitleIsPinnedTVC, image: .pin.withTintColor(.ypBlack)) { [weak self] _ in
                    guard let self else { return }
                    self.attachTracker(tracker: tracker)
                },
                
                UIAction(title: menuTitleEditedTVC, image: .pencilAndListClipboard.withTintColor(.ypBlack)) { [weak self] _ in
                    guard let self else { return }
                    analyticsService.sendEvent(event: .click, screen: .click, item: .edit)
                    self.editTracker(tracker: tracker)
                },
                
                UIAction(title: menuTitleDeleteTVC, image: .trash.withTintColor(.ypRed), attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    analyticsService.sendEvent(event: .click, screen: .click, item: .delete)
                    self.deleteTracker(tracker: tracker)
                }
            ])
        })
    }
    
    func attachTracker(tracker: Tracker) {
        viewModel.updateAttachCategories(tracker)
    }
    
    func deleteTracker(tracker: Tracker) {
        viewModel.updateDeleteTracker(tracker)
    }
    
    func editTracker(tracker: Tracker) {
        let viewModel = NewTrackerEventViewModel(isHabit: tracker.isHabit, editedTracker: tracker, countDay: viewModel.countTrackerExecution(tracker))
        let editedVC = NewTrackerEventViewController(viewModel: viewModel)
        editedVC.delegate = self
        let navigationController = UINavigationController(rootViewController: editedVC)
        navigationController.modalPresentationStyle = .formSheet
        navigationController.navigationBar.tintColor = .ypBlack
        navigationController.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlack
        ]
        present(navigationController, animated: true)
    }
}

extension TrackerViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.resetSearch()
            return
        }
        viewModel.searchTracker(by: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension TrackerViewController: ProtocolNewTrackerEventViewControllerOutput {
    
    func didCreate(newTracker: Tracker, forCategory: String) {
        viewModel.didCreateTracker(newTracker: newTracker, forCategory: forCategory)
    }
    
    func didUpdate(newTracker tracker: Tracker, forCategory: String) {
        viewModel.didUpdateTracker(updatedTracker: tracker, forCategory: forCategory)
    }
}


