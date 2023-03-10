//
//  MemoryGame.swift
//  memorize
//
// This is the model, responsible for for flipping the cards; it is UI independent
//
//  Created by Jay Chulani on 2/16/23.
//

import Foundation

// Whoever calls this struct will need to define what CardContent is (the Don't Care)
struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>         // allow access to cards; but not mutate them
    
    
    // declare func as capable of mutating this model
    mutating func choose(_ card: Card) {
        
        // Flip the card only only if it's face down, otherwise ignore
        // Can't use && (logical AND) when using if let but , does the same thing
        // chosenIndex will get assigned a value first
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}), !cards[chosenIndex].isFaceUp {
            cards[chosenIndex].isFaceUp.toggle()
            print("chosen card = ")
        }
        print(cards)
    }
    
    // Let the ViewModel take care of creating cards; make it pass in the createCardContent func
    // func programming; passing a func to this init func
    init(numberOfPairOfCards: Int, createCardContent: (Int) -> CardContent ) {
        cards = Array<Card>()
        
        // add numberOfPairOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairOfCards {
            let content = createCardContent(pairIndex) // createCardContent is passed in as arg to init
            
            // append called twice; add two cards to the deck with the same content
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2+1))
        }
    }
    
    struct Card: Identifiable {
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent    // CardContent is a generic type aka Dont Care; don't care what it is
        var id: Int                 // Need id as int to be identifiable; makes freaking sense dont it?

    }
}
