import UIKit


final class ScheduleViewController: UIViewController {
    
    var didSelectSchedule: ((Set<DaysOfWeek>) -> Void)?
    
    private var selectedDays: Set<DaysOfWeek> = []
    
    private lazy var readyToUse: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlackDay
        button.titleLabel?.textColor = .ypWhiteDay
        button.addTarget(self, action: #selector(didReadyToUseTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let scheduleTableView = UITableView(frame: view.bounds, style: .insetGrouped)
        scheduleTableView.isScrollEnabled = false
        scheduleTableView.backgroundColor = .clear
        scheduleTableView.separatorStyle = .singleLine
        scheduleTableView.separatorColor = .ypBlackDay
        scheduleTableView.separatorInset.left = 15.95
        scheduleTableView.separatorInset.right = 15.95
        scheduleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        scheduleTableView.layer.masksToBounds = true
        scheduleTableView.layer.cornerRadius = 16
        return scheduleTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.contentInset.top = -19
        
    }
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        [readyToUse, scheduleTableView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false;  view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleTableView.bottomAnchor.constraint(equalTo: readyToUse.topAnchor, constant: -47),
            
            readyToUse.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyToUse.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyToUse.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyToUse.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Расписание"
    }
    
    @objc func didReadyToUseTap() {
        didSelectSchedule?(selectedDays)
        navigationController?.popViewController(animated: true)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DaysOfWeek.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = DaysOfWeek.allCases[indexPath.row].fullName
        cell.backgroundColor = .ypBackgroundDay
        cell.selectionStyle = .none
        
        let switchControl = UISwitch()
        switchControl.onTintColor = .ypBlue
        switchControl.tag = indexPath.row
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        cell.accessoryView = switchControl
        
        return cell
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            selectedDays.insert(DaysOfWeek.allCases[sender.tag])
        } else {
            selectedDays.remove(DaysOfWeek.allCases[sender.tag])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
