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
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                
                // iterate on the cards of the viewModel
                ForEach(game.cards) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            // Ask the game to choose the user's intent
                            game.choose(card)
                        }
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
                    Text(card.content)
                        .font(Font.system(size: min(geometry.size.width, geometry.size.height)*DrawingConstants.fontScale))
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
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()

        EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
    }
}

private struct DrawingConstants {
    static let cornerRadius: CGFloat = 20
    static let lineWidth: CGFloat = 3
    static let fontScale: CGFloat = 0.8
}


