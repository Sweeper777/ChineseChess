protocol Piece : CustomStringConvertible{
    var player: Player { get }
    var localisedDescription: String { get }
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError?
    
}

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
