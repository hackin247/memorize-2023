//
//  ContentView.swift
//  memorize
//
//  Created by Jay Chulani on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    
    var emojis = ["🚲","🚂","🚁","🚜","🚀","✈️","🚗","🚕","🚌","🚎","🏎️","🚓","🚑","🚒","🚐","🛻","🚚","🚛","🚙","🛵","🛴","🛺","🦼","🛰️"]
    
    @State var emojiCount = 20
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(.red)
            }
            Spacer()
            HStack {
                remove
                Spacer()
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var remove: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            VStack{
                Image(systemName: "minus.circle")
            }
        }
    }
    var add: some View {
        Button {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
            
        } label: {
            VStack{
                Image(systemName: "plus.circle")
            }
        }
    }

}


struct CardView: View {

    var content: String
    
    @State var isFaceUp: Bool = true    // @State allow mutation of var inside this view (self); will maintain a pointer outside of this view
    
    var body: some View {
        if isFaceUp {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 20.0)
            
                shape.fill().foregroundColor(.white)
                shape.strokeBorder( lineWidth: 3.0 )
                Text(content)
                    .font(.largeTitle)
            }.onTapGesture {
                isFaceUp = !isFaceUp
            }
        } else {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill()
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
