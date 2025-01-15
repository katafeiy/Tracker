import UIKit

final class ImprovedUITableView: UITableView {
    
    init(frame: CGRect, style: UITableView.Style, isScroll: Bool = false) {
        super.init(frame: frame, style: style)
        isScrollEnabled = isScroll
        separatorStyle = .singleLine
        separatorColor = .ypBlack
        separatorInset.left = 15.95
        separatorInset.right = 15.95
        layer.masksToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .clear
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
