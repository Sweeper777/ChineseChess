import Foundation
import ChessModel

enum APIResult {
    case noBestMove
    case invalidBoard
    case move(Move)
}

enum APIError : Error {
    case invalidEncoding
    case invalidResponseFormat
}

