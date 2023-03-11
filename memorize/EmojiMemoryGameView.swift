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
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)

            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder( lineWidth: 3.0 )
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched{
                
                // hide the card view if it is matched
                shape.opacity(0)
            } else {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()

        EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
    }
}


