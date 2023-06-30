//
//  CardView.swift
//  Memorize
//
//  Created by Aleko Georgiev on 28.06.23.
//

import SwiftUI

struct CardView: View {
    // @State - points to some place in memory that persists after the views are rebuilt; saved in the heap, rather than in the stack, like the other struct properties; views are created and thrown away all the time
    
    private let card: EmojiMemoryGame.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment: .center) {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.shapeStrokeBorderWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .opacity(DrawingConstants.pieOpacity)
                        .padding(DrawingConstants.piePadding)
                    Text(card.content)
                        .font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let shapeStrokeBorderWidth: CGFloat = 4
        static let fontScale: CGFloat = 0.6
        static let pieOpacity: CGFloat = 0.5
        static let piePadding: CGFloat = 8
    }
}
