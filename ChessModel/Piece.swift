enum Player : CustomStringConvertible{
    case red
    case black
    
    var description: String {
        switch self {
        case .red:
            return "Red"
        case .black:
            return "Black"
        }
    }
}
