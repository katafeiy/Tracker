import UIKit

protocol ProtocolNewHabitViewControllerOutput: AnyObject {
    func didCreate(newTracker: Tracker, forCategory: String)
}

final class NewHabitViewController: BaseModelViewController, UIGestureRecognizerDelegate {
    
    weak var delegate: ProtocolNewHabitViewControllerOutput?
    
    private var nameCategory: String?
    
    private var selectedDays: Set<DaysOfWeek> = [] {
        didSet {
            blockUpdateButton()
        }
    }
    
    lazy var nameCell = [("Категория", "Название категории"), ("Расписание", "Дни недели")]

    private lazy var nameTracker: UITextField = {
        var nameTracker = madeTextField(placeholder: .tracker)
        nameTracker.addTarget(self, action: #selector(didChangeName(_ :)), for: .editingChanged)
        return nameTracker
    }()
    
    private lazy var subtitleNameTracker: UILabel = {
        let subtitleNameTracker = madeSubtitleLabel()
        return subtitleNameTracker
    }()
    
    private lazy var limitedTextField: LimitedTextField = {
        let limitedTextField = LimitedTextField(characterLimit: 38,
                                                subtitleLabel: subtitleNameTracker)
        return limitedTextField
    }()
    
    private lazy var tableView: UITableView = {
        let newHabitTableView = madeTableView()
        return newHabitTableView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = madeScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = madeContentView()
        return contentView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = madeCollectionView()
        collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.cellIdentifier)
        collectionView.register(
            EmojiHeaderCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiHeaderCollectionViewCell.headerIdentifier)
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = madeCollectionView()
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.cellIdentifier)
        collectionView.register(
            ColorHeaderCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ColorHeaderCollectionViewCell.headerIdentifier)
        return collectionView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = madeStackView(view: [cancelButton, createNewTrackerButton], axis: .horizontal)
        return stackView
    }()
    
    private lazy var createNewTrackerButton: UIButton = {
        let createButton = madeButton(title: .create,
                                      titleColor: .ypWhiteDay,
                                      backgroundColor: .ypGray)
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(didCreateNewTrackerButtonTap), for: .touchUpInside)
        return createButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = madeButton(title: .cancel,
                                      titleColor: .ypRed,
                                      backgroundColor: .ypWhiteDay)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.addTarget(self, action: #selector(didCancelButtonTap), for: .touchUpInside)
        return cancelButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    func setupUI() {
        
        view.backgroundColor = .white
        nameTracker.delegate = limitedTextField
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = -9
        
        addViewToSubView(view: [scrollView, stackView], subView: view)
        
        addViewToSubView(view: [contentView], subView: scrollView)
        
        addViewToSubView(view: [nameTracker, subtitleNameTracker, tableView, emojiCollectionView, colorCollectionView], subView: contentView)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTracker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTracker.heightAnchor.constraint(equalToConstant: 75),
            
            subtitleNameTracker.topAnchor.constraint(equalTo: nameTracker.bottomAnchor),
            subtitleNameTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleNameTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleNameTracker.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: nameTracker.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 190),
            
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func didChangeName(_ sender: UITextField) {
        blockUpdateButton()
    }
    
    @objc func didCreateNewTrackerButtonTap() {
        
        guard let emojiIndexPath  = emojiCollectionView.indexPathsForSelectedItems?.first else { return }
        guard let colorIndexPath  = colorCollectionView.indexPathsForSelectedItems?.first else { return }
        guard let nameCategory = nameCategory else { return }
        
        delegate?.didCreate(newTracker: .init(id: UUID(),
                                              name: nameTracker.text ?? "nil",
                                              color: ColorCollectionViewCell.colorCell[colorIndexPath.row],
                                              emoji: "\(EmojiCollectionViewCell.emojiCell[emojiIndexPath.row])",
                                              schedule: selectedDays),
                            forCategory: nameCategory)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didCancelButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    
    private func blockUpdateButton() {
        
        guard let textInput = nameTracker.text else { return }
        
        if
            textInput.isEmpty == true ||
                textInput.count > 38 ||
                selectedDays.isEmpty ||
                emojiCollectionView.indexPathsForSelectedItems?.first == nil ||
                colorCollectionView.indexPathsForSelectedItems?.first == nil ||
                nameCategory == nil
        {
            createNewTrackerButton.isEnabled = false
            createNewTrackerButton.backgroundColor = .ypGray
        } else {
            createNewTrackerButton.isEnabled = true
            createNewTrackerButton.backgroundColor = .ypBlackDay
        }
    }
}

extension NewHabitViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollectionView ? EmojiCollectionViewCell.emojiCell.count : ColorCollectionViewCell.colorCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case emojiCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? EmojiCollectionViewCell else { return UICollectionViewCell() }
            
            cell.emojiLabel.text = "\(EmojiCollectionViewCell.emojiCell[indexPath.row])"
            return cell
        case colorCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            cell.colorLabel.backgroundColor = ColorCollectionViewCell.colorCell[indexPath.row]
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case emojiCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.emojiLabel.backgroundColor = .ypLightGray
        case colorCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = ColorCollectionViewCell.colorCell[indexPath.row].withAlphaComponent(0.3).cgColor
        default: break
        }
        blockUpdateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case emojiCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.emojiLabel.backgroundColor = .ypWhiteDay
        case colorCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.layer.borderWidth = 0
            cell?.layer.borderColor = UIColor.clear.cgColor
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch collectionView {
        case emojiCollectionView:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: EmojiHeaderCollectionViewCell.headerIdentifier,
                for: indexPath
            ) as? EmojiHeaderCollectionViewCell else { return UICollectionReusableView() }
            
            headerView.emojiHeaderLabel.text = "Emoji"
            return headerView
        case colorCollectionView:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ColorHeaderCollectionViewCell.headerIdentifier,
                for: indexPath) as? ColorHeaderCollectionViewCell else { return UICollectionReusableView() }
            
            headerView.colorHeaderLabel.text = "Цвет"
            return headerView
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 18)
    }
}

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.backgroundColor = .ypBackgroundDay
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.selectionStyle = .none
        
        cell.textLabel?.text = nameCell[indexPath.row].0
        cell.detailTextLabel?.text = nameCell[indexPath.row].1
        cell.detailTextLabel?.textColor = .ypGray
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            let viewModel = CategoryListViewModel(selectedCategory: nameCategory)
            let categoryListViewController = CategoryListViewController(viewModel: viewModel)
            
            categoryListViewController.didSelectCategory = { [weak self] category in
                guard let self else { return }
                self.nameCategory = category
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.detailTextLabel?.text = category
                }
            }
            
            navigationController?.pushViewController(categoryListViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.didSelectSchedule = { [weak self] schedule in
                guard let self else { return }
                
                if schedule == Set(DaysOfWeek.allCases) {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.detailTextLabel?.text = "Каждый день"
                    }
                } else {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        let sortedSchedule = schedule.sorted(by: {$0.rawValue < $1.rawValue})
                        cell.detailTextLabel?.text = sortedSchedule.reduce("") { $0 + $1.shortName + ", "}
                            .trimmingCharacters(in:.whitespacesAndNewlines)
                            .trimmingCharacters(in: .punctuationCharacters)
                    }
                }
                self.selectedDays = schedule
            }
            navigationController?.pushViewController(scheduleViewController, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

