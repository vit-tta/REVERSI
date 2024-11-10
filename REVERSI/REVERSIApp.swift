//
//  REVERSIApp.swift
//  REVERSI
//
//  Created by Виталия on 04.11.2024.
//

import SwiftUI

@main
struct REVERSIApp: App {
    @StateObject private var game = ReversiGame()
    var body: some Scene {
        WindowGroup {
            GameModeView(game:game)
            
        }
    }
}
