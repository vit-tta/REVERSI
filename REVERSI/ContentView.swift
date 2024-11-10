//
//  ContentView.swift
//  REVERSI
//
//  Created by Виталия on 04.11.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var game: ReversiGame
    @State private var showingAlert = false
    @State private var showingAlert1 = false
    @State private var showGameModeView = false
    init(gameMode: GameMode, game: ReversiGame) {
            self.game = game  // передаем game из родительского компонента
            self.gameViewModel = GameViewModel(gameMode: gameMode)  // Инициализируем GameViewModel с выбранным режимом
        }
    var body: some View {
        HStack{
            Text("Player 1⚫: \(gameViewModel.scorePlayer1)")
                .font(.title)
                .bold()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            Text("Player 2⚪: \(gameViewModel.scorePlayer2)")
                .font(.title)
                .bold()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        
        VStack {
            Text("Current Player: \(gameViewModel.currentPlayer.name)")
                .font(.title3)
                .bold()
                .foregroundColor(.black)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: boardSize), spacing: 4) {
                ForEach(0..<boardSize, id: \.self) { row in
                    ForEach(0..<boardSize, id: \.self) { col in
                        CellView(cell: gameViewModel.board[row][col])
                            .onTapGesture {
                                gameViewModel.makeMove(row: row, col: col)
                            }
                    }
                }
            }
            .padding()
            if let message = gameViewModel.gameOverMessage {
                Text(message)
                    .font(.title)
                    .padding()
            }
            
            Button("Restart Game") {
                showingAlert = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Confirm"),
                                message: Text("Are you sure you want to restart the game?"),
                                primaryButton: .destructive(Text("Ok")) {
                                    gameViewModel.resetGame()
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
            Button("Back to Menu") {
                showingAlert1 = true
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .alert(isPresented: $showingAlert1) {
                                        Alert(
                                            title: Text("Confirm"),
                                            message: Text("Are you sure you want to back to Menu?"),
                                            primaryButton: .destructive(Text("Ok")) {
                                                showGameModeView = true
                                            },
                                            secondaryButton: .cancel(Text("Cancel"))
                                        )
                                    }
                        .fullScreenCover(isPresented: $showGameModeView) {
                            GameModeView(game:game) // Показываем GameModeView
                        }
        }
    }
}
// Представление отдельной клетки на поле
struct CellView: View {
    let cell: Cell
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(7)
            
            if let player = cell.player {
                Circle()
                    .fill(player.color)
                    .padding(4)
            }
        }
    }
}
