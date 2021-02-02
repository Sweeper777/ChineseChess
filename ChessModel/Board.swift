public protocol Board {
    func piece(at position: Position) -> Piece?
}

}

public extension Board {
    subscript(_ position: Position) -> Piece? {
        piece(at: position)
    }
}

