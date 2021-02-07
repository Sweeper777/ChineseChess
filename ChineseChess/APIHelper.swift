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

func requestNextMove(game: Game, completion: @escaping (Result<APIResult, Error>) -> ()) {
    guard var urlComponents = URLComponents(string: "https://www.chessdb.cn/chessdb.php") else {
        completion(.failure(URLError(URLError.badURL)))
        return
    }
    urlComponents.queryItems = [
        URLQueryItem(name: "action", value: "querybest"),
        URLQueryItem(name: "board", value: game.fenFormatString()),
    ]

    guard let url = urlComponents.url else {
        completion(.failure(URLError(URLError.badURL)))
        return
    }
    var request = URLRequest(url: url, timeoutInterval: Double.infinity)

    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            completion(.failure(error!))
            return
        }

        completion(parseResponseData(data))
    }

    task.resume()
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