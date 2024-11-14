import UIKit

protocol ProtocolNewHabitViewControllerOutput: AnyObject {
    func didCreate(newTracker: Tracker, forCategory: String)
}

final class NewHabitViewController: UIViewController {
    
    weak var delegate: ProtocolNewHabitViewControllerOutput?
    
    let nameCell = ["Категория", "Расписание"]
    
    let nameTracker: UITextField = {
        let nameTracker = UITextField()
        nameTracker.placeholder = "Введите название трекера"
        nameTracker.backgroundColor = .ypBackgroundDay
        nameTracker.font = .systemFont(ofSize: 17, weight: .regular)
        nameTracker.textColor = .ypBlackDay
        nameTracker.layer.masksToBounds = true
        nameTracker.layer.cornerRadius = 16
        return nameTracker
    }()
    
    private lazy var newHabitTableView: UITableView = {
        let newHabitTableView = UITableView()
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
            
            newHabitTableView.topAnchor.constraint(equalTo: nameTracker.bottomAnchor, constant: 24),
            newHabitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newHabitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newHabitTableView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новая привычка"
    }
    
    @objc func didCreateNewTrackerButtonTap() {
        
        delegate?.didCreate(newTracker: .init(id: UUID(),name: nameTracker.text ?? "nil", color: .colorSelection1, emoji: "🤩", schedule: [.thu, .sat]),
                            forCategory: "Спорт")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didCancelButtonTap() {
        dismiss(animated: true , completion: nil)
    }
}

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = nameCell[indexPath.row]
        cell.backgroundColor = .ypLightGray
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
            navigationController?.pushViewController(scheduleViewController, animated: true)
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

