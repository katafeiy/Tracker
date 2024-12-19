import UIKit

final class ImprovedUILabel: UILabel {
    
    init(text: String? = nil, fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor, numberOfLines: Int = 1) {
        super.init(frame: .zero)
        self.text = text
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
