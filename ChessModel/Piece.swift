public protocol Piece : CustomStringConvertible {
    var player: Player { get }
    var localisedDescription: String { get }
    var abbreviation: String { get }
    
    /// precondition:
    /// - all positions are in range
    /// - move.to has a piece of the opposing player, or is empty
    /// does not guarantee validation of king in check after the move
    func validateMove(_ move: Move, in board: Board) -> MoveError?
    
    /// postcondition:
    /// - move.from == position
    func allMoves(from position: Position, in board: Board) -> [Move]
    
}

public enum Player : CustomStringConvertible{
    case red
    case black
    
    public var description: String {
        switch self {
        case .red:
            return "Red"
        case .black:
            return "Black"
        }
    }
    
    public var opponent: Player {
        switch self {
        case .red:
            return .black
        case .black:
            return .red
        }
    }
}
