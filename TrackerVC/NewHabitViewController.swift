import UIKit

protocol ProtocolNewHabitViewControllerOutput: AnyObject {
    func didCreate(newTracker: Tracker, forCategory: String)
}

final class NewHabitViewController: UIViewController, UIGestureRecognizerDelegate {
    
    weak var delegate: ProtocolNewHabitViewControllerOutput?
    
    private var selectedDays: Set<DaysOfWeek> = [] {
        didSet {
            blockUpdateButton()
        }
    }
    
    lazy var nameCell = [("Категория", "Название категории"), ("Расписание", "Дни недели")]
    
    let emojiCell: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱" , "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🏅", "🎸", "🏝️", "😪"]
    
    
    private lazy var nameTracker: UITextField = {
        var nameTracker = UITextField()
        nameTracker.placeholder = "Введите название трекера"
        nameTracker.backgroundColor = .ypBackgroundDay
        nameTracker.font = .systemFont(ofSize: 17, weight: .regular)
        nameTracker.textColor = .ypBlackDay
        nameTracker.layer.masksToBounds = true
        nameTracker.layer.cornerRadius = 16
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        nameTracker.leftView = paddingView
        nameTracker.leftViewMode = .always
        nameTracker.clearButtonMode = .whileEditing
        nameTracker.addTarget(self, action: #selector(didChangeName(_ :)), for: .editingChanged)
        nameTracker.delegate = self
        return nameTracker
    }()
    
    private lazy var subtitleNameTracker: UILabel = {
        let subtitle = UILabel()
        subtitle.font = .systemFont(ofSize: 17, weight: .regular)
        subtitle.textColor = .ypLightGray
        subtitle.textAlignment = .center
        return subtitle
    }()
    
    private lazy var tableView: UITableView = {
        let newHabitTableView = UITableView(frame: view.bounds, style: .insetGrouped)
        newHabitTableView.isScrollEnabled = false
        newHabitTableView.backgroundColor = .clear
        newHabitTableView.separatorStyle = .singleLine
        newHabitTableView.separatorColor = .ypBlackDay
        newHabitTableView.separatorInset.left = 15.95
        newHabitTableView.separatorInset.right = 15.95
        newHabitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        newHabitTableView.layer.masksToBounds = true
        newHabitTableView.layer.cornerRadius = 16
        return newHabitTableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        collectionView.register(EmojiHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emojiHeader")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var createNewTrackerButton: UIButton = {
        let createButton = UIButton()
        createButton.isEnabled = false
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhiteDay, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        createButton.backgroundColor = .ypGray
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(didCreateNewTrackerButtonTap), for: .touchUpInside)
        return createButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        cancelButton.backgroundColor = .ypWhiteDay
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
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
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = -9
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createNewTrackerButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        [nameTracker, subtitleNameTracker, tableView, collectionView, stackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            nameTracker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTracker.heightAnchor.constraint(equalToConstant: 75),
            
            subtitleNameTracker.topAnchor.constraint(equalTo: nameTracker.bottomAnchor),
            subtitleNameTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleNameTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleNameTracker.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: nameTracker.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 204),
            collectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            
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
        
        guard let indexPath  = collectionView.indexPathsForSelectedItems?.first else { return }
        
        delegate?.didCreate(newTracker: .init(id: UUID(),
                                              name: nameTracker.text ?? "nil",
                                              color: .colorSelection1,
                                              emoji: "\(emojiCell[indexPath.row])",
                                              schedule: selectedDays),
                            forCategory: "Новая категория")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didCancelButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    
    private func blockUpdateButton() {
        
        guard let textInput = nameTracker.text else { return }
        
        if textInput.isEmpty == true || textInput.count > 38 || selectedDays.isEmpty || emojiCell.isEmpty {
            
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
        return emojiCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }
        cell.emojiLabel.text = "\(emojiCell[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        cell?.emojiLabel.backgroundColor = .ypLightGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        cell?.emojiLabel.backgroundColor = .ypWhiteDay
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "emojiHeader",
                                                                               for: indexPath) as? EmojiHeaderCollectionViewCell else { return UICollectionReusableView() }
        headerView.emojiHeaderLabel.text = "Emoji"
        return headerView
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
            let newCategoryViewController = CreateNewCategoryViewController()
            navigationController?.pushViewController(newCategoryViewController, animated: true)
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
                        cell.detailTextLabel?.text = schedule.reduce("") { $0 + $1.rawValue + ", "}
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

extension NewHabitViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return true }
        let newText = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        
        let count = newText.count < 38 ? newText.count : 38
        let remainingCharacters = 38 - count
        subtitleNameTracker.text = count < 38 ? ("Осталось \(remainingCharacters) символов") : ("Ограничение \(count) символов")
        subtitleNameTracker.textColor = count < 38 ? .ypLightGray : .ypRed
        return newText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTracker.resignFirstResponder()
        return true
    }
}
