//
//  Array+Index.swift
//  testGrid
//
//  Created by Tatiana Kornilova on 6/15/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

extension Array {
    func indexOfElement <T:Equatable>  (item:T) -> Int? {
        for i in 0..self.count {
            if ((self[i] as? T) == item )
            {
                return i
            }
        }
        return nil
    }
}
