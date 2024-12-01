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
        
        labelAlert.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelAlert)
        
        NSLayoutConstraint.activate([
            labelAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelAlert.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension NewIrregularEventViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
}
