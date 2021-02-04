public struct Move : Equatable, CustomStringConvertible {
    public let from: Position
    public let to: Position
    
    public var dx: Int {
        to.x - from.x
    }
    
    public var dy: Int {
        to.y - from.y
    }
    
    public var description: String {
        "Move from \(from) to \(to)"
    }

    public init(from: Position, to: Position) {
        self.from = from
        self.to = to
    }
}

public enum MoveResult {
    case success
    case check
    case checkmate
    case stalemate
}

public enum MoveError : Error {
    case invalidPosition
    case blocked
    case checked
    case opponentsPiece
}
