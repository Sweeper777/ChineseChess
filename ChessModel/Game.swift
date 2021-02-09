public class Game : Board{
    var board = Array2D<Piece?>(columns: 9, rows: 10, initialValue: nil)
    public var currentPlayer = Player.red
    public var opposingPlayer: Player {
        currentPlayer.opponent
    }

    public func allPositions(of player: Player) -> [Position] {
        allPositions(of: player, in: board)
    }
    
    public func kingPosition(of player: Player) -> Position {
        kingPosition(of: player, in: board)
    }
    
    func allPositions(of player: Player, in board: Array2D<Piece?>) -> [Position] {
        board.indicesOf { $0?.player == player }
    }
    
    func kingPosition(of player: Player, in board: Array2D<Piece?>) -> Position {
        board.firstIndex(where: { $0 is King && $0?.player == player })!
    }
    
    public func piece(at position: Position) -> Piece? {
        board[safe: position] as? Piece
    }
    
    public init() {
        board[0, 0] = Chariot(.black)
        board[1, 0] = Horse(.black)
        board[2, 0] = Elephant(.black)
        board[3, 0] = Advisor(.black)
        board[4, 0] = King(.black)
        board[5, 0] = Advisor(.black)
        board[6, 0] = Elephant(.black)
        board[7, 0] = Horse(.black)
        board[8, 0] = Chariot(.black)
        board[1, 2] = Cannon(.black)
        board[7, 2] = Cannon(.black)
        for x in stride(from: 0, through: 8, by: 2) {
            board[x, 3] = Soldier(.black)
        }
        
        board[0, 9] = Chariot(.red)
        board[1, 9] = Horse(.red)
        board[2, 9] = Elephant(.red)
        board[3, 9] = Advisor(.red)
        board[4, 9] = King(.red)
        board[5, 9] = Advisor(.red)
        board[6, 9] = Elephant(.red)
        board[7, 9] = Horse(.red)
        board[8, 9] = Chariot(.red)
        board[1, 7] = Cannon(.red)
        board[7, 7] = Cannon(.red)
        for x in stride(from: 0, through: 8, by: 2) {
            board[x, 6] = Soldier(.red)
        }
    }
    
    func validateMoveRangeAndDestination(move: Move, player: Player) throws -> Piece {
        guard let movingPiece = board[safe: move.from] as? Piece,
              let destination = board[safe: move.to] else {
            throw MoveError.invalidPosition
        }
        if destination?.player == player {
            throw MoveError.invalidPosition
        }
        return movingPiece
    }
    
    private func validateKingInCheck(move: Move, player: Player) throws {
        // try this move
        var boardCopy = board
        boardCopy[move.to] = board[move.from]
        boardCopy[move.from] = nil
        
        // check if king in check
        let kingPos = kingPosition(of: player, in: boardCopy)
        let allOpposingPositions = allPositions(of: player.opponent, in: boardCopy)
        if allOpposingPositions.contains(where: {
            let attackingPiece = boardCopy[$0]
            let error = attackingPiece?.validateMove(Move(from: $0, to: kingPos), in: boardCopy)
            return error == nil
        }) {
            throw MoveError.checked
        }
    }
    
    public func validateMove(_ move: Move) throws {
        
        let movingPiece = try validateMoveRangeAndDestination(move: move, player: currentPlayer)
        
        guard movingPiece.player == currentPlayer else {
            throw MoveError.opponentsPiece
        }
        
        if let pieceRulesError = movingPiece.validateMove(move, in: board) {
            throw pieceRulesError
        }
        
        try validateKingInCheck(move: move, player: currentPlayer)
    }
    
    public func makeMove(_ move: Move) throws -> MoveResult {
        guard let movingPiece = board[safe: move.from] else {
            throw MoveError.invalidPosition
        }
        try validateMove(move)
        board[move.to] = movingPiece
        board[move.from] = nil
        
        // check/checkmate
        let opposingKingPos = kingPosition(of: opposingPlayer)
        let allMyPositions = allPositions(of: currentPlayer)
        let check = allMyPositions.contains(where: {
            let attackingPiece = board[$0]
            return attackingPiece?.validateMove(Move(from: $0, to: opposingKingPos), in: board) == nil
        })
        let allOpposingPositions = allPositions(of: opposingPlayer)
        let allOpposingMoves = allOpposingPositions.flatMap { board[$0]?.allMoves(from: $0, in: board) ?? [] }
        let opposingPlayerHasNoMoves = allOpposingMoves.filter {
            (try? validateMoveRangeAndDestination(move: $0, player: opposingPlayer)) != nil &&
            (try? validateKingInCheck(move: $0, player: opposingPlayer)) != nil
        }.isEmpty
        currentPlayer = opposingPlayer
        switch (check, opposingPlayerHasNoMoves)  {
        case (false, false):
            return .success
        case (true, false):
            return .check
        case (false, true):
            return .stalemate
        case (true, true):
            return .checkmate
        }
    }
}
