//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Aleko Georgiev on 27.06.23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // game is ther view model
    
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var  dealingNamespace
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isNotDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    // returns something that behaves like a view
    var body: some View {
        
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
                .foregroundColor(game.color)
                .bold()
                .padding(.bottom)
            
            Text("Score: \(game.score)")
                .font(.title)
                .bold()
                .foregroundColor(game.color)
            
            ZStack(alignment: .bottom) {
                deckBody
                gameBody
            }
            
            Spacer()
            
            newGameButton
        }
        .padding(.horizontal)
    }
    
    private func dealCards() {
        withAnimation  {
            for card in game.cards {
                deal(card)
            }
        }
    }
    
    private var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isNotDealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.chooseCard(card)
                        }
                    }
            }
        }
        .foregroundColor(game.color)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * ( Double(3) / Double(game.cards.count) )
        }
        
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
        
    }
    
    private var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isNotDealt)) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .scale, removal: .identity).animation(Animation.easeInOut(duration: 1)))
                    .zIndex(zIndex(of: card))

            }
            .frame(width: EmojiMemoryGameConstants.undealtCardsWidth, height: EmojiMemoryGameConstants.undealtCardsHeigth)
            .foregroundColor(game.color)
            .onTapGesture {
                for card in game.cards {
                    withAnimation (dealAnimation(for: card))  {
                        deal(card)
                    }
                }
            }
        }
    }
    
    private var newGameButton: some View {
        Button {
            withAnimation {
                dealt = []
                game.refreshGame()
            }
        } label: {
            Text("New Game")
                .font(.title)
                .foregroundColor(game.color)
                .bold()
                .padding(EmojiMemoryGameConstants.buttonLabelPadding)
        }
    }
    
    private struct EmojiMemoryGameConstants {
        static let newGameButtonWidth: CGFloat = 200
        static let newGameButtonHeight: CGFloat = 100
        static let newGameButtonCornerRadius: CGFloat = 12
        static let newGameButtonPadding: CGFloat = 16
        static let undealtCardsWidth: CGFloat = 70
        static let undealtCardsHeigth: CGFloat = 105
        static let buttonLabelPadding: CGFloat = 30
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
