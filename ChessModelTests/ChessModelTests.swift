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
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        }
    }
}
