import UIKit

final class NewIrregularEventViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новое нерегулярное событие"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension NewIrregularEventViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
}
