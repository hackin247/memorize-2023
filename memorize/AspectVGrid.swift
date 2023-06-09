//
//  AspectVGrid.swift
//  memorize
//
//  Created by Jay Chulani on 6/7/23.
//

import SwiftUI

// Item is a don't care; specify inside <>
struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    
    var items: [Item]                   // we dont care what the items are
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder  content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    // helper func to set spacing to 0; makes widthThatFits func work
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
            var columnCount = 1
            var rowCount = itemCount
            
            repeat {
                let itemWidth = size.width / CGFloat(columnCount)
                let itemHeight = itemWidth / itemAspectRatio
                if CGFloat(rowCount) * itemHeight < size.height {
                    break
                }
                columnCount += 1
                rowCount = (itemCount + (columnCount - 1)) / columnCount
            } while columnCount < itemCount
            if columnCount > itemCount {
                columnCount = itemCount
            }
            return floor(size.width / CGFloat(columnCount))
        }
}


//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}

struct Previews_AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
