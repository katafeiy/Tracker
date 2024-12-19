import UIKit

enum TrackerColors: Int, CaseIterable {
    
    case tartOrange
    case beer
    case azure
    case veryLightBlue
    case ufoGreen
    case orchid
    case palePink
    case brilliantAzure
    case eucalyptus
    case cosmicCobalt
    case tomato
    case paleMagentaPink
    case macaroniAndCheese
    case cornflowerBlue
    case blueViolet
    case mediumOrchid
    case mediumPurple
    case ufoZoneGreen
    
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
        .tartOrange,
        .beer,
        .azure,
        .veryLightBlue,
        .ufoGreen,
        .orchid,
        .palePink,
        .brilliantAzure,
        .eucalyptus,
        .cosmicCobalt,
        .tomato,
        .paleMagentaPink,
        .macaroniAndCheese,
        .cornflowerBlue,
        .blueViolet,
        .mediumOrchid,
        .mediumPurple,
        .ufoZoneGreen
    ]
}


