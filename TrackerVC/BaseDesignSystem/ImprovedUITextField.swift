import UIKit

class ImprovedUITextField: UITextField {
    
    enum PlaceholderText {
        case tracker
        case category
        
        var text: String {
            return switch self {
            case .tracker: "Введите название трекера"
            case .category: "Введите название категории"
            }
        }
    }
    
    init(placeholder: PlaceholderText) {
        super.init(frame: .zero)
        self.placeholder = placeholder.text
        backgroundColor = .ypBackgroundDay
        font = .systemFont(ofSize: 17, weight: .regular)
        textColor = .ypBlackDay
        layer.masksToBounds = true
        layer.cornerRadius = 16
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        leftView = paddingView
        leftViewMode = .always
        clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LimitedTextField: NSObject, UITextFieldDelegate {
    
    private var characterLimit: Int?
    private weak var subtitleLabel: UILabel?
    
    init(characterLimit: Int?, subtitleLabel: UILabel?) {
        self.characterLimit = characterLimit
        self.subtitleLabel = subtitleLabel
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard
            let textFieldText = textField.text,
            let characterLimit,
            let subtitleLabel
        else { return true }
        
        let newText = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        let count = min(newText.count, characterLimit)
        let remainingCharacters = characterLimit - count
        
        subtitleLabel.text = count < characterLimit ? ("Осталось \(remainingCharacters) символов") : ("Ограничение \(count) символов")
        subtitleLabel.textColor = count < characterLimit ? .ypLightGray : .ypRed
        
        return newText.count <= characterLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
