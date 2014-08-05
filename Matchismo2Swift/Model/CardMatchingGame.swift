//
//  CardMatchingGame.swift
//  Matchismo2Swift
//
//  Created by Tatiana Kornilova on 6/14/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import UIKit

class CardMatchingGame {
    var score:Int = 0
    var cards:[Card]
    var faceUpCards:[Card]
    var lastFlipPoints:Int = 0
    
    var numberOfMatches:Int = 2
    
    var matchedCards:[Card]
    
    init (cardCount:Int, deck:Deck ){
        self.cards = [Card]()
        self.faceUpCards = [Card]()
        self.matchedCards = [Card]()
        for i in 0..<cardCount {
            var card:Card? = deck.drawRandomCard()
            if card != nil {
                cards.append(card!)
            }
        }
    }
    
    func cardAtIndex(index:Int) ->Card?
    {
        return index<countElements(self.cards) ? self.cards[index] : nil;
    }
    
    let MISMATCH_PENALTY:Int = 2
    let MATCH_BONUS:Int = 4
    let COST_TO_CHOOSE:Int = 1
    
    func chooseCard(atIndex:Int)
    {
        var card:Card? = cardAtIndex(atIndex)
        self.faceUpCards = [Card]()
        if card != nil {
            if (!card!.isMatched) {
                if (card!.isChosen) {
                    card!.isChosen = false
                } else {
                    // match against another cards
                    faceUpCards.append(card!)
                    self.lastFlipPoints = 0;
                    for otherCard:Card in self.cards {
                        if (otherCard.isChosen && !otherCard.isMatched) {
                            self.faceUpCards.insert(otherCard, atIndex: 0)
                            // decision on match
                            if countElements(self.faceUpCards) == (self.numberOfMatches) {
                                
                                var matchScore:Int = card!.match(self.faceUpCards)
                                if matchScore > 0 {
                                    self.lastFlipPoints = matchScore * MATCH_BONUS
                                    for faceUpCard in self.faceUpCards {
                                        faceUpCard.isMatched = true
                                    }
                                    
                                } else {
                                    self.lastFlipPoints = -MISMATCH_PENALTY
                                    for faceUpCard in self.faceUpCards {
                                        if faceUpCard !== card {faceUpCard.isChosen = false}
                                    }
                                }
                                self.matchedCards = self.faceUpCards
                                break;
                            }
                            // decision on match
                        }
                    }
                    self.score += (self.lastFlipPoints - COST_TO_CHOOSE)
                    self.matchedCards = self.faceUpCards
                    card!.isChosen = true
                }
            }
        }
    }
    
}
