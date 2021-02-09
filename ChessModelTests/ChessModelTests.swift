//
//  ChessModelTests.swift
//  ChessModelTests
//
//  Created by Mulang Su on 23/1/2021.
//

import XCTest
@testable import ChessModel

class ChessModelTests: XCTestCase {

    func testKingMoves() throws {
        let game = Game()
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(4, 9), to: Position(4, 8))))
        var pieceAtDestination = game.piece(at: Position(4, 8))
        XCTAssertTrue(pieceAtDestination is King, "Piece at (4, 8) is \(pieceAtDestination?.description ?? "nil"), expected King")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(4, 8), to: Position(4, 9))))
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(4, 0), to: Position(5, 0))))
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(4, 0), to: Position(4, 1))))
        pieceAtDestination = game.piece(at: Position(4, 1))
        XCTAssertTrue(pieceAtDestination is King, "Piece at (4, 1) is \(pieceAtDestination?.description ?? "nil"), expected King")
        
        game.board = Array2D(columns: 9, rows: 10, initialValue: nil)
        game.board[4, 0] = King(.black)
        game.board[3, 9] = King(.red)
        XCTAssertThrowsError(try game.validateMove(Move(from: Position(3, 9), to: Position(4, 9))))
        XCTAssertThrowsError(try game.validateMove(Move(from: Position(4, 0), to: Position(3, 0))))
        game.board[4, 5] = Cannon(.black)
        game.board[3, 5] = Cannon(.black)
        try game.validateMove(Move(from: Position(3, 9), to: Position(4, 9)))
        try game.validateMove(Move(from: Position(3, 9), to: Position(4, 9)))
    }
    
    func testAdvisorMoves() throws {
        let game = Game()
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(3, 9), to: Position(4, 8))))
        var pieceAtDestination = game.piece(at: Position(4, 8))
        XCTAssertTrue(pieceAtDestination is Advisor, "Piece at (4, 8) is \(pieceAtDestination?.description ?? "nil"), expected Advisor")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(3, 0), to: Position(2, 1))))
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(3, 0), to: Position(3, 2))))
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(3, 0), to: Position(4, 1))))
        pieceAtDestination = game.piece(at: Position(4, 1))
        XCTAssertTrue(pieceAtDestination is Advisor, "Piece at (4, 1) is \(pieceAtDestination?.description ?? "nil"), expected Advisor")
    }
    
    func testElephantMoves() throws {
        let game = Game()
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(2, 9), to: Position(4, 7))))
        var pieceAtDestination = game.piece(at: Position(4, 7))
        XCTAssertTrue(pieceAtDestination is Elephant, "Piece at (4, 7) is \(pieceAtDestination?.description ?? "nil"), expected Elephant")
        
        game.board[3, 1] = Chariot(.black)
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 0), to: Position(4, 2))))
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(2, 0), to: Position(0, 2))))
        pieceAtDestination = game.piece(at: Position(0, 2))
        XCTAssertTrue(pieceAtDestination is Elephant, "Piece at (0, 2) is \(pieceAtDestination?.description ?? "nil"), expected Elephant")
    }
    
    func testHorseMoves() throws {
        let game = Game()
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(1, 9), to: Position(2, 7))))
        var pieceAtDestination = game.piece(at: Position(2, 7))
        XCTAssertTrue(pieceAtDestination is Horse, "Piece at (2, 7) is \(pieceAtDestination?.description ?? "nil"), expected Horse")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(1, 0), to: Position(3, 1))))
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(1, 0), to: Position(0, 2))))
        pieceAtDestination = game.piece(at: Position(0, 2))
        XCTAssertTrue(pieceAtDestination is Horse, "Piece at (0, 2) is \(pieceAtDestination?.description ?? "nil"), expected Horse")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 7), to: Position(3, 5))))
    }
    
    func testChariotMoves() throws {
        let game = Game()
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(0, 9), to: Position(0, 7))))
        let pieceAtDestination = game.piece(at: Position(0, 7))
        XCTAssertTrue(pieceAtDestination is Chariot, "Piece at (0, 7) is \(pieceAtDestination?.description ?? "nil"), expected Chariot")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(0, 0), to: Position(0, 8))))
    }
    
    func testSoldierMoves() throws {
        let game = Game()
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 6), to: Position(1, 6))))
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 6), to: Position(2, 7))))
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(2, 6), to: Position(2, 5))))
        var pieceAtDestination = game.piece(at: Position(2, 5))
        XCTAssertTrue(pieceAtDestination is Soldier, "Piece at (2, 5) is \(pieceAtDestination?.description ?? "nil"), expected Soldier")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 3), to: Position(1, 3))))
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 3), to: Position(2, 2))))
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(2, 3), to: Position(2, 4))))
        pieceAtDestination = game.piece(at: Position(2, 4))
        XCTAssertTrue(pieceAtDestination is Soldier, "Piece at (2, 4) is \(pieceAtDestination?.description ?? "nil"), expected Soldier")
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(2, 5), to: Position(2, 4))))
        pieceAtDestination = game.piece(at: Position(2, 4))
        XCTAssertTrue(pieceAtDestination is Soldier, "Piece at (2, 4) is \(pieceAtDestination?.description ?? "nil"), expected Soldier")
        
        game.currentPlayer = .red
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(2, 4), to: Position(1, 4))))
        pieceAtDestination = game.piece(at: Position(1, 4))
        XCTAssertTrue(pieceAtDestination is Soldier, "Piece at (1, 4) is \(pieceAtDestination?.description ?? "nil"), expected Soldier")
    }
    
    func testCannonMoves() throws {
        let game = Game()
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(1, 7), to: Position(1, 3))))
        let pieceAtDestination = game.piece(at: Position(1, 3))
        XCTAssertTrue(pieceAtDestination is Cannon, "Piece at (1, 3) is \(pieceAtDestination?.description ?? "nil"), expected Cannon")
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(1, 2), to: Position(1, 8))))
        
    }
    
    func testCannonCaptures() throws {
        let game = Game()
        
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(1, 7), to: Position(1, 0))))
        var pieceAtDestination = game.piece(at: Position(1, 0))
        XCTAssertTrue(pieceAtDestination is Cannon, "Piece at (1, 0) is \(pieceAtDestination?.description ?? "nil"), expected Cannon")
        
        game.board = Array2D(columns: 9, rows: 10, initialValue: nil)
        game.board[4, 0] = King(.black)
        game.board[3, 9] = King(.red)
        game.board[4, 5] = Cannon(.black)
        game.board[3, 5] = Soldier(.red)
        game.board[2, 5] = Chariot(.red)
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 5), to: Position(3, 5))))
        XCTAssertEqual(MoveResult.success,
                       try game.makeMove(Move(from: Position(4, 5), to: Position(2, 5))))
        pieceAtDestination = game.piece(at: Position(2, 5))
        XCTAssertTrue(pieceAtDestination is Cannon, "Piece at (2, 5) is \(pieceAtDestination?.description ?? "nil"), expected Cannon")
        game.board[4, 5] = Soldier(.black)
        
        XCTAssertThrowsError(try game.makeMove(Move(from: Position(2, 5), to: Position(4, 5))))
    }
    
    func testAllMovesValid() throws {
        let game = Game()
        for position in game.allPositions(of: .red) {
            if let piece = game.piece(at: position) {
                let allMoves = piece.allMoves(from: position, in: game.board)
                for move in allMoves {
                    if (try? game.validateMoveRangeAndDestination(move: move, player: game.currentPlayer)) == nil {
                        continue
                    }
                    XCTAssertNil(piece.validateMove(move, in: game.board), "\(move) is not a valid move!")
                }
            }
        }
    }

    func testFalsePositiveStalemate() throws {
        let game = Game()
        _ = try game.makeMove(Move(from: Position(6, 6), to: Position(6, 5)))
        _ = try game.makeMove(Move(from: Position(4, 3), to: Position(4, 4)))
        _ = try game.makeMove(Move(from: Position(4, 6), to: Position(4, 5)))
        let moveResult = try game.makeMove(Move(from: Position(4, 4), to: Position(4, 5)))
        XCTAssertEqual(MoveResult.success, moveResult)
    }
}
