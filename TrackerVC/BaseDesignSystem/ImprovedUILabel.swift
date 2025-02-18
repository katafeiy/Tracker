import UIKit

final class ImprovedUILabel: UILabel {
    
    init(
        text: String? = nil,
        fontSize: CGFloat,
        weight: UIFont.Weight,
        textColor: UIColor,
        numberOfLines: Int = 1,
        cornerRadius: CGFloat = 0,
        textAlignment: NSTextAlignment = .center
    ) {
        super.init(frame: .zero)
        self.text = text
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
