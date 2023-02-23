//
//  EmojiMemoryGame.swift
//  memorize
//  This is the View Model
//  - acts as gatekeeper
//  - interprets data between the model and view
//
//  Created by Jay Chulani on 2/16/23.
//

import SwiftUI


class EmojiMemoryGame {
    
    static var emojis = ["🚲","🚂","🚁","🚜","🚀","✈️","🚗","🚕","🚌","🚎","🏎️","🚓","🚑","🚒","🚐","🛻","🚚","🚛","🚙","🛵","🛴","🛺","🦼","🛰️"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // model is a MemoryGame with strings as CardContent
    private var model: MemoryGame<String> = createMemoryGame()
    
    // Public var
    var cards: Array<MemoryGame<String>.Card> {
        model.cards                      // return the cards from the model
    }
}
