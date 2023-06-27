//
//  MemoryGame.swift
//  Memorize
//
//  Created by Aleko Georgiev on 28.06.23.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var score: Int
    private var indexOfFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ chosen: Card) {
        if let index = cards.firstIndex (where: { $0.id == chosen.id }), !cards[index].isFaceUp, !cards[index].isMatched {
            if let potentialMatchIndex = indexOfFaceUpCard {
                if cards[index].content == cards[potentialMatchIndex].content {
                    cards[index].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    score -= 1
                }
                cards[index].isFaceUp = true
            } else {
                indexOfFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        score = 0
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content ))
            cards.append(Card(id: pairIndex * 2 + 1, content: content ))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        let id: Int

        let content: CardContent
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        
        func isEqual(to card: Card) -> Bool {
            self.content == card.content
        }
    }
    
    struct Theme {
        let name: String
        var emojis: [String]
        let numOfPairs: Int
        let color: String
        
        init(name: String, emojis: [String], numOfPairs: Int, color: String) {
            self.name = name
            self.emojis = emojis
            self.numOfPairs = numOfPairs > emojis.count ? emojis.count : numOfPairs
            self.color = color
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        }
        return nil
    }
}
