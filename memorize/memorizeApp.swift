//
//  memorizeApp.swift
//  memorize
//
//  Created by Jay Chulani on 2/10/23.
//

import SwiftUI

@main
struct memorizeApp: App {
    private let game = EmojiMemoryGame()    // declare constant and assign it the pointer to a reference type (class)
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
