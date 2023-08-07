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
        get {cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        set {cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}} // Flip all cards down except the one that is faceUp
    }
        
    // declare func as capable of mutating this model
    mutating func choose(_ card: Card) {
        
        // Flip the card only only if it's face down, otherwise ignore
        // Can't use && (logical AND) when using if let but , does the same thing
        // chosenIndex will get assigned a value first
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
            !cards[chosenIndex].isFaceUp,           // Flip the card only only if it's face down
            !cards[chosenIndex].isMatched          // Flip the card only only if it's not alreadyt matched
        {
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
                cards[chosenIndex].isFaceUp = true
                //indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                
                // set the index of the faceUp card
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            // flip the chosen card
            //cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
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
        
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent    // CardContent is a generic type aka Dont Care; don't care what it is
        let id: Int                 // Need id as int to be identifiable; makes freaking sense dont it?
        
        
        // MARK: - Bonus Time
            // MARK: This section of code is not my own it was provided by the CS193p team as part of lecture 8
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        // MARK: - End of code provided by CS193p lecture 8

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
