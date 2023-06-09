//
//  EmojiMemoryGameView.swift
//  memorize
//
//  Created by Jay Chulani on 2/10/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    // Making this @ObservedObject will force body to be redrawn
    // any time the game publishes a change
    @ObservedObject var  game: EmojiMemoryGame      // Declare a constant for the ViewModel
    
    var body: some View {
        
        // Create a view combiner that maintains the size grid items using an aspect ratio;
        // dynamically resize depending on the number of cards
        //
        // Params:
        // - the cards in the grid aka items
        // - the desired aspect ratio (CGFloat)
        // - content aka function that returns a view >> CardView?
        //
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            
            if card.isMatched && card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        // Ask the game to choose the user's intent
                        game.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}


struct CardView: View {

    // This CardView takes a Card and builds a body from it
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)

                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder( lineWidth: DrawingConstants.lineWidth )
                    Pie(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 45), clockwise: true)
                        .padding(5)
                        .opacity(0.5)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched{
                    
                    // hide the card view if it is matched
                    shape.opacity(0)
                } else {
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill()
                }
            }

        })
    }
    
    // Utility function that takes a CGSize and returns a font
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}

private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 3
    static let fontScale: CGFloat = 0.7
}


