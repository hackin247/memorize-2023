//
//  MemoryGame.swift
//  memorize
//
// This is the model, will contain the game logic
// responsible for for flipping the cards; it is UI independent
//
//  Created by Jay Chulani on 2/16/23.
//

import Foundation

// Whoever calls this struct will need to define what CardContent is (the Don't Care)
// - but we also have to tag CardContent as equatable so we can compare contents
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>         // allow access to cards; but not mutate them
    
    // need a var to track a card that was previously flipped, and face up.
    //
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    
    // declare func as capable of mutating this model
    mutating func choose(_ card: Card) {
        
        // Flip the card only only if it's face down, otherwise ignore
        // Can't use && (logical AND) when using if let but , does the same thing
        // chosenIndex will get assigned a value first
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
            !cards[chosenIndex].isFaceUp,           // Flip the card only only if it's face down
            !cards[chosenIndex].isMatched {         // Flip the card only only if it's not alreadyt matched
            
            // ok we flipped a card, now what?
            // Check if there's already a card that is face up (not nil)
            if let potentialIndexMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                
                // check if the cards match!
                // will show an error unless CardContent is Equatable
                if cards[chosenIndex].content == cards[potentialIndexMatchIndex].content {
                    
                    // If the contents match, mark the cards as matched
                    cards[chosenIndex].isMatched = true
                    cards[potentialIndexMatchIndex].isMatched = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
                
            } else {
                
                // either two cards are face up, or all are face down (can't wrap my head around this yet)
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                
                // set the index of the face up card
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }

            // always toggle the chosen card
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
        let content: CardContent    // CardContent is a generic type aka Dont Care; don't care what it is
        let id: Int                 // Need id as int to be identifiable; makes freaking sense dont it?

    }
}
