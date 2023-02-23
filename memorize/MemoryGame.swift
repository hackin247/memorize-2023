//
//  MemoryGame.swift
//  memorize
//
// This is the model; it is UI independent
//
//  Created by Jay Chulani on 2/16/23.
//

import Foundation

// CardContent is a generic type; don't care what it is
// - whoever calls this struct will define what CardContent is
struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>         // allow access to cards; but not mutate them
    
    // model is responsible for flipping the cards
    func choose(_ card: Card) {
        
    }
    
    // Let the ViewModel take care of creating cards; make it pass in the createCardContent func
    // func programming; passing a func to this init func
    init(numberOfPairOfCards: Int, createCardContent: (Int) -> CardContent ) {
        cards = Array<Card>()
        
        // add numberOfPairOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairOfCards {
            let content = createCardContent(pairIndex) // createCardContent is passed in as arg to init
            
            // append called twice 
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2+1))
        }
    }
    
    struct Card: Identifiable {
        
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int                 // Need id as int to be identifiable; makes freaking sense dont it?

    }
}
