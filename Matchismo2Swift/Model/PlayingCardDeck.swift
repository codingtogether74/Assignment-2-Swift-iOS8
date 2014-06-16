//
//  PlayingCardDeck.swift
//  MatchismoSwift
//
//  Created by Tatiana Kornilova on 6/11/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation
// A class representing Playing card Deck.
class PlayingCardDeck: Deck {
    init ()
    {
        super.init()
        for suit in PlayingCard.validSuits() {
            for var rank = 1; rank <= PlayingCard.maxRank(); ++rank {
                var card:PlayingCard = PlayingCard(suit: suit,rank: rank)
                card.rank = rank
                card.suit = suit
                self.cards += card
            }
        }
    }
    
}