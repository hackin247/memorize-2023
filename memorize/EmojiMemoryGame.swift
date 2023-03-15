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

// Making it conform to ObservableObject, allows others to subscribe to published changes
class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    private static var emojis = ["🚲","🚂","🚁","🚜","🚀","✈️","🚗","🚕","🚌","🚎","🏎️","🚓","🚑","🚒","🚐","🛻","🚚","🚛","🚙","🛵","🛴","🛺","🦼","🛰️"]

    // Function tht returns a MemoryGame model
    // - Defines the CardContent as String
    private static func createMemoryGame() -> MemoryGame<String> {
        
        // init for MemoryGame takes an int (numberOfPairOfCards) and a function
        MemoryGame<String>(numberOfPairOfCards: 8) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // model is a MemoryGame with strings as CardContent
    // Making @Published will automatically invoke objectWillChange.send()
    @Published private var model = createMemoryGame()
    
    // Public var
    var cards: Array<Card> {
        model.cards                      // return the cards from the model
    }
    
    // MARK: - intent(s)
    
    // This viewModel will express the user's intent
    func choose(_ card: Card) {
        
        // But it is the model that actually acts on the user's intent
        model.choose(card)
    }
}
