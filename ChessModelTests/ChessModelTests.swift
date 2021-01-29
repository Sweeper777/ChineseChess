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
    
    }
        }
    }
}
