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
            
            if card.isMatched && !card.isFaceUp {
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
                Pie(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 45), clockwise: true)
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.easeOut(duration: 20))
                    .font(font(in: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)

        })
    }
    
    // Utility function that takes a CGSize and returns a font
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}




