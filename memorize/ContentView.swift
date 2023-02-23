//
//  ContentView.swift
//  memorize
//
//  Created by Jay Chulani on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    
    let viewModel: EmojiMemoryGame      // Declare a constant for the ViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                
                // iterate on the cards of the viewModel
                ForEach(viewModel.cards) { card in
                    CardView(card: card).aspectRatio(2/3, contentMode: .fit)
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
        if card.isFaceUp {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 20.0)
            
                shape.fill().foregroundColor(.white)
                shape.strokeBorder( lineWidth: 3.0 )
                Text(card.content)
                    .font(.largeTitle)
            }
        } else {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill()
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()

        ContentView(viewModel: game).preferredColorScheme(.dark)
        ContentView(viewModel: game).preferredColorScheme(.light)
    }
}


