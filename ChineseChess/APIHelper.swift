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


fileprivate func parseResponseData(_ data: Data) -> Result<APIResult, Error> {
    guard let responseString = String(data: data, encoding: .utf8) else {
        return .failure(APIError.invalidEncoding)
    }
    if responseString.starts(with: "nobestmove") {
        return .success(.noBestMove)
    } else if responseString.starts(with: "invalid board") {
        return .success(.invalidBoard)
    } else {
        guard let indexOfColon = responseString.firstIndex(of: ":") else {
            return .failure(APIError.invalidResponseFormat)
        }
        let iccsMoveString = String(responseString[responseString.index(after: indexOfColon)...].prefix(4))
        guard let move = Move(iccsString: iccsMoveString) else {
            return .failure(APIError.invalidResponseFormat)
        }
        return .success(.move(move))
    }
}