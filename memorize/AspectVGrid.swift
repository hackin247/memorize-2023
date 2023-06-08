//
//  AspectVGrid.swift
//  memorize
//
//  Created by Jay Chulani on 6/7/23.
//

import SwiftUI

// Item is a don't care; specify inside <>
struct AspectVGrid<Item, ItemView>: View where ItemView: View {
    
    var items: [Item]                   // we dont care what the items are
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
