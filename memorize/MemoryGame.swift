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
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        
        set {
            // Flip all cards down except the one that is faceUp
            cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}
            
//            for index in cards.indices {
//                // isFaceUp is only true if index is the same as the newValue
//                if index != newValue {
//                    cards[index].isFaceUp = false
//                } else {
//                    cards[index].isFaceUp = true
//                }
//            }
            
        }
    }
    
    
    // declare func as capable of mutating this model
    mutating func choose(_ card: Card) {
        
        // Flip the card only only if it's face down, otherwise ignore
        // Can't use && (logical AND) when using if let but , does the same thing
        // chosenIndex will get assigned a value first
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
            !cards[chosenIndex].isFaceUp,           // Flip the card only only if it's face down
            !cards[chosenIndex].isMatched {         // Flip the card only only if it's not alreadyt matched
            
            // ok a card was chosen, now what?
            // Check if there's already a card that is face up (index is not nil)
            
            if let potentialIndexMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                
                // There is a faceUp card
                
                // Card matched logic
                // will show an error unless CardContent is Equatable
                if cards[chosenIndex].content == cards[potentialIndexMatchIndex].content {
                    
                    // If the contents match, mark the cards as matched
                    cards[chosenIndex].isMatched = true
                    cards[potentialIndexMatchIndex].isMatched = true
                }
                
                // flip the chosen card
                cards[chosenIndex].isFaceUp = true
                
            } else {
                
                // set the index of the faceUp card
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }


            
            print("chosen card = ")
        }
        print(cards)
    }
    
    // Let the ViewModel take care of creating cards; make it pass in the createCardContent func
    // func programming; passing a func to this init func
    init(numberOfPairOfCards: Int, createCardContent: (Int) -> CardContent ) {
        cards = []
        
        // add numberOfPairOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairOfCards {
            let content = createCardContent(pairIndex) // createCardContent is passed in as arg to init
            
            // append called twice; add two cards to the deck with the same content
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2+1))
        }
    }
    
    struct Card: Identifiable {
        
        var isFaceUp = false
        var isMatched = false
        let content: CardContent    // CardContent is a generic type aka Dont Care; don't care what it is
        let id: Int                 // Need id as int to be identifiable; makes freaking sense dont it?

    }
}

// Add an extension to Array that returns the Element (Don't care type for Array)
// that returns of the only faceUp card; else returns nil
extension Array {
    
    // Can't have stored vars in extensions, they have to be computed
    
    var oneAndOnly: Element? {       // Making it optional because we can also return nil
        
        // return an index if there is only one faceUp card
        // return nil otherwise
        if count == 1 {                 // count is short for self.count
            return first                // first is short for self.first
        } else {
            return nil
        }
    }
}
