import UIKit

final class ScheduleViewController: BaseModelViewController {
    
    var didSelectSchedule: ((Set<DaysOfWeek>) -> Void)?
    
    private var selectedDays: Set<DaysOfWeek> = []
    
    private lazy var readyToUse: UIButton = {
        let button = madeButton(title: .ready,
                                titleColor: .ypWhiteDay,
                                backgroundColor: .ypBlackDay)
        button.addTarget(self, action: #selector(didReadyToUseTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let scheduleTableView = madeTableView()
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
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubviews(readyToUse, scheduleTableView)
        
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
    
    private  func setupNavigationBar() {
        navigationItem.title = "Расписание"
        navigationItem.hidesBackButton = true
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
