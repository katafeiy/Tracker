import UIKit

protocol ProtocolNewHabitViewControllerOutput: AnyObject {
    func didCreate(newTracker: Tracker, forCategory: String)
}

final class NewHabitViewController: UIViewController {
    
    weak var delegate: ProtocolNewHabitViewControllerOutput?
    
    private var selectedDays: Set<DaysOfWeek> = [] {
        didSet {
            blockUpdateButton()
        }
    }
    
    lazy var nameCell = [("Категория", "Название категории"), ("Расписание", "Дни недели")]
    
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
    
    
    private lazy var newHabitTableView: UITableView = {
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
        newHabitTableView.dataSource = self
        newHabitTableView.delegate = self
        newHabitTableView.contentInset.top = -9
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createNewTrackerButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        [nameTracker, newHabitTableView, stackView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false;  view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            nameTracker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTracker.heightAnchor.constraint(equalToConstant: 75),
            
            newHabitTableView.topAnchor.constraint(equalTo: nameTracker.bottomAnchor),
            newHabitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newHabitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newHabitTableView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новая привычка"
    }
    
    @objc func didChangeName(_ sender: UITextField) {
        blockUpdateButton()
    }
    
    @objc func didCreateNewTrackerButtonTap() {
        
        delegate?.didCreate(newTracker: .init(id: UUID(),name: nameTracker.text ?? "nil", color: .colorSelection1, emoji: "🤩", schedule: selectedDays),
                            forCategory: "Новая категория")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didCancelButtonTap() {
        dismiss(animated: true , completion: nil)
    }
    
    private func blockUpdateButton() {
        
        guard let textInput = nameTracker.text else { return }
        
        if textInput.isEmpty == true || textInput.count > 38 || selectedDays.isEmpty {
            
            createNewTrackerButton.isEnabled = false
            createNewTrackerButton.backgroundColor = .ypGray
        } else {
            createNewTrackerButton.isEnabled = true
            createNewTrackerButton.backgroundColor = .ypBlackDay
        }
    }
}

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.detailTextLabel?.text = schedule.reduce("") { $0 + $1.rawValue + ", "}
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return true }
        let newText = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        
        let remainingCharacters = 38 - newText.count
        print("Осталось \(remainingCharacters) символов")
        
        return newText.count <= 38
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTracker.resignFirstResponder()
        return true
    }
}

