import UIKit

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
