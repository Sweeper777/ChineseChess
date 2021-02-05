import ChessModel

extension Position {
    var iccsString: String {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        let x = letters[self.x]
        let y = "\(9 - self.y)"
        return "\(x)\(y)"
    }

    init?(iccsString: String) {
        let letters: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        guard iccsString.count == 2 else {
            return nil
        }
        guard let x = letters.firstIndex(of: iccsString[iccsString.startIndex]) else {
            return nil
        }
        guard let y = iccsString[iccsString.index(after: iccsString.startIndex)].wholeNumberValue else {
            return nil
        }
        guard (0..<10).contains(y) else {
            return nil
        }
        self.init(x, y)
    }
}

