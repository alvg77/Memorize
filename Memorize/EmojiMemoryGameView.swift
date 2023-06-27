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
    
    // returns something that behaves like a view
    var body: some View {
        
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
                .foregroundColor(game.color)
                .bold()
                .padding(.bottom)
            Text(game.theme.name)
                .font(.title)
                .bold()
                .foregroundColor(game.color)
            
            AspectVGrid (items: game.cards, aspectRatio: 2/3, content: { card in
                cardView(for: card)
            })
            .foregroundColor(game.color)
            Spacer()
            Text("Score: \(game.score)")
                .font(.title2)
                .padding(.bottom)
                .bold()
            Spacer()
            newGameButton
        }
        .padding(.horizontal)
    }
    
    private var newGameButton: some View {
        Button {
            game.refreshGame()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 100)
                    .foregroundColor(game.color)
                    .cornerRadius(10)
                    .padding(.all, 15)
                Text("New Game")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }

    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        CardView(card)
            .padding(4)
            .onTapGesture {
                game.chooseCard(card)
            }
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
