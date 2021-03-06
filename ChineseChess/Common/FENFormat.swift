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
        self.init(x, 9 - y)
    }
}

extension Game {
    func fenFormatString() -> String {
        var rows = [String]()
        for y in 0..<10 {
            var row = ""
            var emptyCount = 0
            for x in 0..<9 {
                if let piece = piece(at: Position(x, y)) {
                    if emptyCount > 0 {
                        row += "\(emptyCount)"
                        emptyCount = 0
                    }
                    row += piece.abbreviation
                } else {
                    emptyCount += 1
                }
            }
            if emptyCount > 0 {
                row += "\(emptyCount)"
            }
            rows.append(row)
        }
        let playerString = currentPlayer == .red ? "w" : "b"
        return "\(rows.joined(separator: "/")) \(playerString)"
    }
}

extension Move {
    var iccsString: String {
        "\(from.iccsString)\(to.iccsString)"
    }

    init?(iccsString: String) {
        guard iccsString.count == 4 else {
            return nil
        }
        let splitIndex = iccsString.index(iccsString.startIndex, offsetBy: 2)
        let (fromString, toString) = (iccsString[..<splitIndex], iccsString[splitIndex...])
        guard let from = Position(iccsString: String(fromString)),
              let to = Position(iccsString: String(toString)) else {
            return nil
        }
        self.init(from: from, to: to)
    }
}