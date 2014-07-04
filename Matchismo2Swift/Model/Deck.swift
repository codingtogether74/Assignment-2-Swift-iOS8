//
//  Deck.swift
//  MatchismoSwift
//
//  Created by Tatiana Kornilova on 6/9/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation

// A class representing deck.
class Deck {
    
    var cards: Card[]
    
    func addCard (card: Card){
        cards += card
    }
    
    init(){
        self.cards = Card[]()
    }
    
    func drawRandomCard () -> Card?{
        
        var  randomCard:Card?
        
        if self.cards.count > 0  {
            let index : Int = Int(rand()) % (self.cards.count - 1)
            
            //           let index = Int(arc4random_uniform(UInt32(self.cards.count)))
            
            randomCard = self.cards[index] as Card
            cards.removeAtIndex(index)
        }
        return randomCard
    }
}



