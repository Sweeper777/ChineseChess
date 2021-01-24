public protocol Piece : CustomStringConvertible {
    var player: Player { get }
    var localisedDescription: String { get }
    
    /// precondition:
    /// - all positions are in range
    /// - move.to has a piece of the opposing player, or is empty
    /// does not guarentee validation of king in check after the move
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError?
    
    /// postcondition:
    /// - move.from == position
    func allMoves(from position: Position, in board: Array2D<Piece?>) -> [Move]
    
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
