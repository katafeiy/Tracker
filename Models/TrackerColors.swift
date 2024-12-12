import UIKit

enum TrackerColors: Int, CaseIterable {
    
    case colorSelection1
    case colorSelection2
    case colorSelection3
    case colorSelection4
    case colorSelection5
    case colorSelection6
    case colorSelection7
    case colorSelection8
    case colorSelection9
    case colorSelection10
    case colorSelection11
    case colorSelection12
    case colorSelection13
    case colorSelection14
    case colorSelection15
    case colorSelection16
    case colorSelection17
    case colorSelection18
    
    var color: UIColor {
        return TrackerColors.colorCell[self.rawValue]
    }
    
    init?(color: UIColor) {
        guard
            let colorIndex = TrackerColors.colorCell.firstIndex(where: { $0 == color }),
            let value = TrackerColors.init(rawValue: colorIndex)
        else { return nil }
        self = value
    }
    
    static let colorCell: [UIColor] = [
        .colorSelection1,
        .colorSelection2,
        .colorSelection3,
        .colorSelection4,
        .colorSelection5,
        .colorSelection6,
        .colorSelection7,
        .colorSelection8,
        .colorSelection9,
        .colorSelection10,
        .colorSelection11,
        .colorSelection12,
        .colorSelection13,
        .colorSelection14,
        .colorSelection15,
        .colorSelection16,
        .colorSelection17,
        .colorSelection18
    ]
}


