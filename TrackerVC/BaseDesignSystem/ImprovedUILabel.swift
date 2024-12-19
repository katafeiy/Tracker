import UIKit

final class ImprovedUILabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 17, weight: .regular)
        textColor = .ypLightGray
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
