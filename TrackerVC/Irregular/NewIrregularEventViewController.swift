import UIKit

final class NewIrregularEventViewController: UIViewController {
    
    let labelAlert: UILabel = {
        let label = UILabel()
        label.text = "Уважаемый ревьювер!)))\n" +
                    "Реализация функционала\n" +
                    "данного контроллера\n" +
                    "произойдет в 16-ом спринте!)))\n" +
                    "Честное слово!!!"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 10
        return label
    }()
    
    private lazy var buttonOK: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapOK), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новое нерегулярное событие"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupUI() {
        
        [labelAlert, buttonOK].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            labelAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelAlert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonOK.centerXAnchor.constraint(equalTo: labelAlert.centerXAnchor),
            buttonOK.topAnchor.constraint(equalTo: labelAlert.bottomAnchor, constant: 16),
            buttonOK.heightAnchor.constraint(equalToConstant: 60),
            buttonOK.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func didTapOK() {
        navigationController?.popViewController(animated: true)
    }
}

extension NewIrregularEventViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
}
