//
//  CardView.swift
//  Memorize
//
//  Created by Aleko Georgiev on 28.06.23.
//

import SwiftUI

struct CardView: View {
    // @State - points to some place in memory that persists after the views are rebuilt; saved in the heap, rather than in the stack, like the other struct properties; views are created and thrown away all the time
    
    private var card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment: .center) {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (-animatedBonusRemaining) * 360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (-card.bonusRemaining) * 360-90))
                    }
                }
                .opacity(DrawingConstants.pieOpacity)
                .padding(DrawingConstants.piePadding)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(.easeInOut(duration: 2))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(toFit: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(toFit size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.6
        static let pieOpacity: CGFloat = 0.5
        static let piePadding: CGFloat = 8
        static let fontSize: CGFloat = 32
    }
}
