//
//  CardGameViewController.swift
//  MatchismoSwift
//
//  Created by Tatiana Kornilova on 6/14/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import UIKit

class CardGameViewController: UIViewController {
    
    @IBOutlet var padView : UIView
    @IBOutlet var resultsLabel : UILabel
    @IBOutlet var scoreLabel : UILabel
    
    var cardButtons:UIButton[]
    var flipCount:Int = 0
    
    let DEFAULT_FACE_CARD_SCALE_FACTOR:Double = 0.95
    
    @lazy var deck: Deck = createDeck(self)()
    
    var game:CardMatchingGame? = nil
    var cardCount:Int = 16
    var numberOfMatches:Int = 2
    
    init(coder aDecoder: NSCoder!) {
        cardButtons = UIButton[] ()
        super.init(coder: aDecoder)
        
    }
    
    func createDeck() ->Deck {
        return PlayingCardDeck()
    }
    
    @IBAction func touchCardButton(sender : UIButton) {
        
        var cardIndex:Int? = self.cardButtons.indexOfElement (sender)
        self.game!.chooseCard(cardIndex!)
        self.flipCount++;
        updateUI()
    }
    
    func updateUI ()
    {
        for  cardButton:UIButton in cardButtons {
            var cardIndex:Int? = self.cardButtons.indexOfElement (cardButton)
            if cardIndex {
                var card:Card? = self.game!.cardAtIndex(cardIndex!)
                //            print(card!.contents)
                if card {
                    cardButton.setTitle(titleForCard(card!), forState:UIControlState.Normal)
                    cardButton.setBackgroundImage(UIImage(named:backgroundImageForCard(card!)), forState:UIControlState.Normal)
                    cardButton.enabled = !card!.isMatched
                }
            }
        }
        self.scoreLabel.text = "Score: \(self.game!.score)"
        updateFlipResult()
        
    }
    
    func updateFlipResult()
    {
        var text:String = " ";
        if self.game!.matchedCards.count > 0
        {
            text = text + joinComponentsByString(self.game!.matchedCards,joinedString:" ")
            if self.game!.matchedCards.count == self.numberOfMatches
            {
                if (self.game!.lastFlipPoints<0) {
                    text = text + "✘ \(self.game!.lastFlipPoints) penalty"
                } else {
                    text = text + "✔ + \(self.game!.lastFlipPoints) bonus"
                }
            } else {text = textForSingleCard()}
        } else {text = "Play game!"}
        self.resultsLabel.text = text;
    }
    
    func joinComponentsByString(cards:Card [], joinedString: String) -> String {
        var str = ""
        if cards.count > 1 {
            let contentsArray = cards.map { ($0 as Card).contents }
            str = join(joinedString,contentsArray)
        } else {
            str = (cards[0] as Card).contents
        }
        
        return str
    }
    
    func textForSingleCard() ->String
    {
        var text = ""
        if self.game!.matchedCards.count == 1 {
            var card:Card = self.game!.matchedCards[0]
            var cardChoosen:String = card.isChosen ? "up!" : "back!"
            text = " \(card.contents) flipped \(cardChoosen)"
        }
        return text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.game = CardMatchingGame (cardCount:self.cardCount, deck:self.deck )
        if game {self.game!.numberOfMatches = self.numberOfMatches}
        self.resultsLabel.text = ""
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var grid1:Grid =  Grid (cellAspectRatio: 60.0/90.0, size: self.padView.bounds.size , minimumNumberOfCells: self.cardCount)
        var columnCount:Int = grid1.columnCount
        
        var j:Int = 0
        if cardButtons.count > 0 {
            for (var i = 0; i < cardButtons.count; i++) {
                
                var row:Int = j / columnCount
                var column:Int = j  % columnCount
                
                //var center:CGPoint = grid1.centerOfCell(row, column: column)
                var frame:CGRect  = grid1.frameOfCell(row, column: column)
                var factor:CGFloat = CGFloat (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR)
                var frame1:CGRect = CGRectInset(frame,frame.size.width * factor,frame.size.height * factor)
                
                cardButtons[i].frame = frame1
                
                j++;
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var grid1:Grid =  Grid (cellAspectRatio: 60.0/90.0, size: self.padView.bounds.size , minimumNumberOfCells: self.cardCount)
        var columnCount:Int = grid1.columnCount
        
        var j:Int = 0
        for (var i = 0; i < self.cardCount; i++) {
            
            var row:Int = j / columnCount
            var column:Int = j  % columnCount
            
            var center:CGPoint = grid1.centerOfCell(row, column: column)
            var frame:CGRect  = grid1.frameOfCell(row, column: column)
            var factor:CGFloat = CGFloat (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR)
            var frame1:CGRect = CGRectInset(frame,frame.size.width * factor,frame.size.height * factor)
            
            var newButton = UIButton.buttonWithType(.Custom) as UIButton   //UIButton()
            
            newButton.setTitle(nil, forState: .Normal)
            newButton.titleLabel.font = UIFont.systemFontOfSize(24)
            newButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            newButton.frame = frame1
            newButton.setBackgroundImage(UIImage(named:"cardback"), forState: .Normal)
            newButton.addTarget(self, action: "touchCardButton:", forControlEvents: .TouchUpInside)
            self.padView.addSubview(newButton)
            
            cardButtons +=  newButton
            j++;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func titleForCard(card:Card) -> String?
    {
        return card.isChosen ? card.contents : nil
    }
    
    func backgroundImageForCard(card:Card) -> String
    {
        return card.isChosen ? "cardfront" : "cardback"
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
