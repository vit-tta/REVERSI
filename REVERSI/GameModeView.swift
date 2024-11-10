//
//  GameModeView.swift
//  REVERSI
//
//  Created by Виталия on 04.11.2024.
//
import SwiftUI


struct GameModeView: View {
    @State private var selectedMode:  GameMode? 
    @ObservedObject var game: ReversiGame
   
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Game Mode")
                .font(.largeTitle)
                .padding()
            
            Button("Play with Another Player") {
                selectedMode = .twoPlayers
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Button("Play with Computer") {
                selectedMode = .againstComputer
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .fullScreenCover(item: $selectedMode) { mode in
            ContentView(gameMode: mode,game: game)
            
        }
    }
}

// Режимы игры
enum GameMode: Identifiable {
    case twoPlayers, againstComputer
    var id: Int {
        hashValue
    }
}
