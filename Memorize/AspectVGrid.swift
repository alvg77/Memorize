//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Aleko Georgiev on 28.06.23.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            // we put a VStack here so we take up all the space offered by the geometry reader as the vstack is flexible
            VStack {
                let width: CGFloat = calculateSize(numberOfItems: items.count, in: geometry.size, aspectRatio: aspectRatio)
                LazyVGrid(columns: [getGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
        }
    }
    
    private func getGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    // add a column -> calculate width -> calculate heigth from aspectRatio and width -> check if numOfItems * heigth is less than the available space, if so -> get out, if not continue
    private func calculateSize(numberOfItems: Int, in size: CGSize, aspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = numberOfItems
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeigth = itemWidth / aspectRatio

            if (CGFloat(rowCount) * itemHeigth) < size.height {
                break
            }
            columnCount += 1
            rowCount = (numberOfItems + (columnCount - 1)) / columnCount
        } while columnCount < numberOfItems
        
        if columnCount > numberOfItems {
            columnCount = numberOfItems
        }
        
        return floor(size.width / CGFloat(columnCount))
    }
}
