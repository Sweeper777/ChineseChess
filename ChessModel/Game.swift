public class Game {
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
        board[position]
    }
    
    public init() {
    }
    
    func validateMoveRangeAndDestination(move: Move) throws -> Piece {
        guard let movingPiece = board[safe: move.from] as? Piece,
              let destination = board[safe: move.to] else {
            throw MoveError.invalidPosition
        }
        if destination?.player == currentPlayer {
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
    
}
