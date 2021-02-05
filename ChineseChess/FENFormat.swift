import ChessModel

extension Position {
    var iccsString: String {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        let x = letters[self.x]
        let y = "\(9 - self.y)"
        return "\(x)\(y)"
    }

}

