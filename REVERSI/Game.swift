//
//  Game.swift
//  REVERSI
//
//  Created by Виталия on 04.11.2024.
//
import SwiftUI

// Размер игрового поля
let boardSize = 8

// Игроки
enum Player {
    case player1, player2
    
    var opponent: Player {
        return self == .player1 ? .player2 : .player1
    }
    
    var color: Color {
        return self == .player1 ? .black : .white
    }
    
    var name: String {
        return self == .player1 ? "Player 1⚫" : "Player 2⚪"
    }
}


// Игровая клетка
struct Cell {
    var player: Player? = nil
}

// логика игры
class ReversiGame: ObservableObject{
    var board: [[Cell]]
    var currentPlayer: Player = .player1
    var scorePlayer1: Int = 2
    var scorePlayer2: Int = 2
    var gameOverMessage: String? = nil
    var selectedMode: GameMode?
    
    // Инициализатор без параметров, если режим не передается
      init(mode: GameMode? = nil) {
          self.selectedMode = mode // Если режим передан, он будет использован
          board = Array(repeating: Array(repeating: Cell(), count: boardSize), count: boardSize)
          resetGame()
      }
    // Перезапуск игры
    func resetGame() {
        board = Array(repeating: Array(repeating: Cell(), count: boardSize), count: boardSize)
        board[3][3].player = .player2
        board[4][4].player = .player2
        board[3][4].player = .player1
        board[4][3].player = .player1
        currentPlayer = .player1
        updateScores()
        gameOverMessage = nil
    }
    // Обновление счета игроков
    func updateScores() {
        var player1Count = 0
        var player2Count = 0
        for row in board {
            for cell in row {
                if cell.player == .player1 {
                    player1Count += 1
                } else if cell.player == .player2 {
                    player2Count += 1
                }
            }
        }
        scorePlayer1 = player1Count
        scorePlayer2 = player2Count
    }
    
    // Проверка возможности хода
    func isValidMove(row: Int, col: Int, for player: Player) -> Bool {
        if board[row][col].player != nil { return false }
        
        for (dx, dy) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
            var x = row + dx
            var y = col + dy
            var foundOpponent = false
            while isValidPosition(row: x, col: y) {
                if board[x][y].player == player.opponent {
                    foundOpponent = true
                } else if board[x][y].player == player, foundOpponent {
                    return true
                } else {
                    break
                }
                x += dx
                y += dy
            }
        }
        return false
    }
    
    // Проверка, находится ли координата на поле
    private func isValidPosition(row: Int, col: Int) -> Bool {
        return row >= 0 && row < boardSize && col >= 0 && col < boardSize
    }
    
    // Выполнение хода
    func makeMove(row: Int, col: Int) {
        guard isValidMove(row: row, col: col, for: currentPlayer) else { return }
        
        board[row][col].player = currentPlayer
        
        for (dx, dy) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
            var x = row + dx
            var y = col + dy
            var cellsToFlip: [(Int, Int)] = []
            while isValidPosition(row: x, col: y) {
                if board[x][y].player == currentPlayer.opponent {
                    cellsToFlip.append((x, y))
                }
                else if board[x][y].player == currentPlayer {
                    for (flipRow, flipCol) in cellsToFlip {
                        board[flipRow][flipCol].player = currentPlayer
                    }
                    break
                } else {
                    break
                }
                x += dx
                y += dy
            }
        }
       
        updateScores()
        checkGameOver()
        if currentPlayer == .player1 {
                    currentPlayer = .player2
                    // Если игра против компьютера, делаем ход компьютера
                    if selectedMode == .againstComputer {
                        // После хода игрока 1 — игрок 2 (компьютер) делает свой ход
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.randomComputerMove()
                        //}
                    }
                } else {
                    currentPlayer = .player1
                }
        
    }
    func randomComputerMove() {
            let possibleMoves = getPossibleMoves(for: .player2)
            if let randomMove = possibleMoves.randomElement() {
                makeMove(row: randomMove.row, col: randomMove.col)
            }
        }
    func getPossibleMoves(for player: Player) -> [(row: Int, col: Int)] {
            var moves: [(Int, Int)] = []
            for row in 0..<8 {
                for col in 0..<8 {
                    if isValidMove(row: row, col: col, for: player) {
                        moves.append((row, col))
                    }
                }
            }
            return moves
        }
    // Проверка на окончание игры
    func checkGameOver() {
        var hasValidMoves = false
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if isValidMove(row: row, col: col, for: currentPlayer) {
                    hasValidMoves = true
                    break
                }
            }
        }
        if !hasValidMoves {
            if scorePlayer1 > scorePlayer2 {
                gameOverMessage = "Player 1 wins!"
            } else if scorePlayer2 > scorePlayer1 {
                gameOverMessage = "Player 2 wins!"
            } else {
                gameOverMessage = "It's a tie!"
            }
        }
    }
}

