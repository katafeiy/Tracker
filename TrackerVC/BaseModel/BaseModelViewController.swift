import UIKit

class BaseModelViewController: UIViewController {
    
    func madeTextField(placeholder: placeholderText) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder.text
        textField.backgroundColor = .ypBackgroundDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlackDay
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }
    
    func madeSubtitleLabel() -> UILabel {
        let subtitle = UILabel()
        subtitle.font = .systemFont(ofSize: 17, weight: .regular)
        subtitle.textColor = .ypLightGray
        subtitle.textAlignment = .center
        return subtitle
    }
    
    func madeTableView() -> UITableView {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypBlackDay
        tableView.separatorInset.left = 15.95
        tableView.separatorInset.right = 15.95
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        return tableView
    }
    
    func madeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        return scrollView
    }
    
    func madeContentView() -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }
    
    func madeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }
    
    func madeStackView(view: [UIView], axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: view)
        stackView.axis = axis
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }
    
    func madeButton(title: buttonName, titleColor: UIColor, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title.text, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = backgroundColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }
    
    func addViewToSubView(view: [UIView], subView: UIView) {
        view.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview($0)
        }
    }
}

