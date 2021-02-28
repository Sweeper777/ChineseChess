import ChessModel

protocol ChessSceneDelegate : class {
    func didMakeMove(moveResult: MoveResult, player: Player)
    func moveDidError(_ error: MoveError, player: Player)
    func didUnexpectedError(_ error: Error)
}