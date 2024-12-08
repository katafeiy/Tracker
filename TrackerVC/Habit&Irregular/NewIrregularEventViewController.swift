import UIKit

protocol ProtocolNewIrregularEventViewControllerOutput: AnyObject {
    func didCreate(newTracker: Tracker, forCategory: String)
}

final class NewIrregularEventViewController: BaseModelViewController, UIGestureRecognizerDelegate {
    
    weak var delegate: ProtocolNewIrregularEventViewControllerOutput?
    
    private var nameCategory: String?
    
    lazy var nameCell = [("Категория", "Название категории")]
    
    private lazy var nameTracker: UITextField = {
        var nameTracker = madeTextField()
        nameTracker.addTarget(self, action: #selector(didChangeName(_ :)), for: .editingChanged)
        return nameTracker
    }()
    
    private lazy var subtitleNameTracker: UILabel = {
        let subtitleNameTracker = madeSubtitleLabel()
        return subtitleNameTracker
    }()
    
    private lazy var tableView: UITableView = {
        let newIrregularEventTableView = madeTableView()
        return newIrregularEventTableView
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
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createNewTrackerButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
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
        nameTracker.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = -9
        
        [scrollView, stackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [nameTracker, subtitleNameTracker, tableView, emojiCollectionView, colorCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
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
            tableView.heightAnchor.constraint(equalToConstant: 115),
            
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
        navigationItem.title = "Новое нерегулярное событие"
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
                                              schedule: Set(DaysOfWeek.allCases)),
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

extension NewIrregularEventViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollectionView ? EmojiCollectionViewCell.emojiCell.count : ColorCollectionViewCell.colorCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case emojiCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }
            cell.emojiLabel.text = "\(EmojiCollectionViewCell.emojiCell[indexPath.row])"
            return cell
        case colorCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
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
                withReuseIdentifier: "emojiHeader",
                for: indexPath
            ) as? EmojiHeaderCollectionViewCell else { return UICollectionReusableView()}
            headerView.emojiHeaderLabel.text = "Emoji"
            return headerView
        case colorCollectionView:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "colorHeader",
                for: indexPath
            ) as? ColorHeaderCollectionViewCell else { return UICollectionReusableView() }
            headerView.colorHeaderLabel.text = "Цвет"
            return headerView
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 18)
    }
}

extension NewIrregularEventViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension NewIrregularEventViewController: UITextFieldDelegate {
    
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
