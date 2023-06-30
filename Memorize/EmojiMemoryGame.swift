//
//  EmojuMemoryGame.swift
//  Memorize
//
//  Created by Aleko Georgiev on 28.06.23.
//

import SwiftUI
 
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    typealias Theme = MemoryGame<String>.Theme
    
    private static var themes: [Theme] = []
    
    
    private static var vehicleEmojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    private static let expressionEmojis = ["😀", "🤣", "🤬", "🥰", "💀", "🫥", "😈", "😘", "🤯", "🫣", "😜", "🥺", "😰", "😶‍🌫️", "🤡", "🫡", "🫣"]
    private static let jobEmojis = ["🧙‍♂️", "👳‍♂️", "👨🏿‍💻", "👲", "🎅🏻", "🥷🏻"]
    
    
    
    private static let colors = ["yellow", "green", "red", "orange", "blue", "gray", "purple"]
    
    private static func createTheme(_ name: String, emojis: [String], numberOfPairs: Int) {
        themes.append(Theme(name: name, emojis: emojis, numOfPairs: numberOfPairs, color: colors.randomElement()!))
    }
        
    private static func createModel() -> (MemoryGame<String>, Theme) {
        var theme = EmojiMemoryGame.themes.randomElement()!
        theme.emojis.shuffle()
        return (MemoryGame<String>(numberOfPairsOfCards: theme.numOfPairs) { index in theme.emojis[index] }, theme)
    }
    
    init() {
        EmojiMemoryGame.createTheme("Vehicles", emojis: EmojiMemoryGame.vehicleEmojis, numberOfPairs: 6)
        EmojiMemoryGame.createTheme("Expressions", emojis: EmojiMemoryGame.expressionEmojis, numberOfPairs: 8)
        EmojiMemoryGame.createTheme("Jobs", emojis: EmojiMemoryGame.jobEmojis, numberOfPairs: 4)
        
        
        (model, theme) = EmojiMemoryGame.createModel()
    }
        
    @Published private var model: MemoryGame<String>
    private(set) var theme: Theme
    
    var color: Color {
        switch theme.color {
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "red":
            return .red
        case "orange":
            return .orange
        case "blue":
            return .blue
        case "gray":
            return .gray
        case "purple":
            return .purple
        default:
            return .accentColor
        }
    }
    
    func refreshGame() {
        (model, theme) = EmojiMemoryGame.createModel()
    }
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    func chooseCard(_ card: Card) {
        model.choose(card)
    }
}
