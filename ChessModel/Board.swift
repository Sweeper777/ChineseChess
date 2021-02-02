public protocol Board {
    func piece(at position: Position) -> Piece?
}

extension Array2D : Board where T == Piece? {
    public func piece(at position: Position) -> Piece? {
        self[safe: position] as? Piece
    }
}

public extension Board {
    subscript(_ position: Position) -> Piece? {
        piece(at: position)
    }
}

