//
//  GameViewModel.swift
//  REVERSI
//
//  Created by Виталия on 04.11.2024.
//
import SwiftUI
class GameViewModel: ObservableObject {
    @Published private var game: ReversiGame
    // Инициализатор с режимом игры
        init(gameMode: GameMode) {
            game = ReversiGame(mode: gameMode)
        }
    
    var board: [[Cell]] {
        game.board
    }
    var currentPlayer: Player {
        game.currentPlayer
    }
    var scorePlayer1: Int {
        game.scorePlayer1
    }
    var scorePlayer2: Int {
        game.scorePlayer2
    }
    var gameOverMessage: String? {
        game.gameOverMessage
    }
    
    func makeMove(row: Int, col: Int) {
        game.makeMove(row: row, col: col)
        objectWillChange.send()
    }
    
    func resetGame() {
        game.resetGame()
        objectWillChange.send()
    }
}


