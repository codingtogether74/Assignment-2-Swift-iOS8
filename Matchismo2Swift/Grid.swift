//
//  Grid.swift
//  :
//
//  Created by Tatiana Kornilova on 6/15/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

// To use Grid, simply alloc/init one, then
//  decide what aspect ratio you want the things in the grid to have (cellAspectRatio)
//  and how much space you want the grid to take up in total (size)
//  then specify what is the minimum number of cells in the grid you require (minimumNumberOfCells)
//
// After you set those three things above, then you can find out where each cell is either by ...
// ... its center centerOfCell(row:Int, column:Int) ->CGPoint
// ... or its frame func frameOfCell(row:Int, column:Int) ->CGRect
//
// You can also find out how many rows (rowCountGrid) or columns (columnCountGrid) are in the grid
//  and how big each cell is (they will all be the same size)
//
// inputsAreValid will tell you whether your 3 inputs are okay
//
// Setting minimum cell widths and heights is completely optional ({min,max}Cell{Width,Height})

import Foundation
import UIKit

class Grid {
    // required inputs (zero is not a valid value for any of these)
    
    var size:CGSize {                    // overall available space to put grid into
    didSet{
        if CGSizeEqualToSize (oldValue, size) {
            resolved = false
        }
    }
    }
    var cellAspectRatio:CGFloat  {       // width divided by height (of each cell)
    didSet {
        if abs(oldValue) !== abs(cellAspectRatio) {
            resolved = false
        }
        
    }
    }
    var minimumNumberOfCells:Int {
    didSet{
        if oldValue != minimumNumberOfCells {
            resolved = false
        }
    }
    }
    
    // optional inputs (non-positive values are ignored)
    
    var minCellWidth:CGFloat = 0{
    didSet{
        if oldValue != minCellWidth {
            resolved = false
        }
    }
    }
    
    var maxCellWidth:CGFloat  = 0 {    // ignored if less than minCellWidth
    didSet{
        if oldValue != maxCellWidth {
            resolved = false
        }
    }
    }
    
    var minCellHeight:CGFloat = 0 {
    didSet{
        if oldValue != minCellHeight {
            resolved = false
        }
    }
    }
    
    var maxCellHeight:CGFloat = 0 {   // ignored if less than minCellHeight
    didSet{
        if oldValue != maxCellHeight {
            resolved = false
        }
    }
    }
    
    // calculated outputs (value of NO or 0 or CGSizeZero means "invalid inputs")
    
    var inputsAreValid:Bool {   // cells will fit into requested size
    get{
        validate()
        return self.resolved
    }
    }
    var cellSize:CGSize  = CGSizeZero    // will be made as large as possible
    
    var rowCount:Int = 0
    
    var columnCount:Int = 0
    
    //internal
    var resolved:Bool{
    didSet{
        self.unresolvable = false
    }
    }
    
    var unresolvable:Bool
    
    init(cellAspectRatio:CGFloat, size:CGSize,minimumNumberOfCells:Int ){
        
        self.size = size
        self.cellAspectRatio = cellAspectRatio
        self.minimumNumberOfCells = minimumNumberOfCells
        self.resolved = false
        self.unresolvable = false
        if !self.inputsAreValid {
            println (self.description())
        }
        
    }
    
    // ------ funcs -------------------------------
    
    func validate() ->Void
    {
        if resolved {return}   // already valid, nothing to do
        if unresolvable {return}  // already tried to validate and couldn't
        
        var overallWidth:CGFloat = abs(self.size.width)
        var overallHeight:CGFloat = abs(self.size.height);
        var aspectRatio:CGFloat = abs(self.cellAspectRatio);
        
        if  aspectRatio == 0.0 || overallWidth == 0.0 || overallHeight  == 0.0 {
            self.unresolvable = true
            return // invalid inputs
        }
        
        var minCellWidth:CGFloat = self.minCellWidth;
        var minCellHeight:CGFloat = self.minCellHeight;
        var maxCellWidth :CGFloat = self.maxCellWidth;
        var maxCellHeight:CGFloat = self.maxCellHeight;
        
        var flipped:Bool = false
        if (aspectRatio > 1) {
            flipped = true
            overallHeight = abs(self.size.width);
            overallWidth = abs(self.size.height);
            aspectRatio = 1.0/aspectRatio;
            minCellWidth = self.minCellHeight;
            minCellHeight = self.minCellWidth;
            maxCellWidth = self.maxCellHeight;
            maxCellHeight = self.maxCellWidth;
        }
        
        if minCellWidth < 0 {minCellWidth = 0}
        if minCellHeight < 0 {minCellHeight = 0}
        
        var columnCount:Int = 1;
        while (!self.resolved && !self.unresolvable) {
            var cellWidth:CGFloat = overallWidth / CGFloat(columnCount)
            if cellWidth <= minCellWidth {
                self.unresolvable = true
            } else {
                var cellHeight:CGFloat = cellWidth / aspectRatio;
                if cellHeight <= minCellHeight {
                    self.unresolvable = true
                } else {
                    var rowCount:Int = Int(overallHeight / cellHeight);
                    if (rowCount * columnCount >= self.minimumNumberOfCells) &&
                        ((maxCellWidth <= minCellWidth) || (cellWidth <= maxCellWidth)) &&
                        ((maxCellHeight <= minCellHeight) || (cellHeight <= maxCellHeight)) {
                            if flipped {
                                self.rowCount = columnCount;
                                self.columnCount = rowCount;
                                self.cellSize = CGSizeMake(cellHeight, cellWidth);
                            } else {
                                self.rowCount = rowCount;
                                self.columnCount = columnCount;
                                self.cellSize = CGSizeMake(cellWidth, cellHeight);
                            }
                            self.resolved = true
                    }
                    columnCount++;
                }
            }
        }
        
        if (!self.resolved) {
            self.rowCount = 0;
            self.columnCount = 0;
            self.cellSize = CGSizeZero;
        }
    }
    
    func rowCountGrid() ->Int {
        validate()
        return self.rowCount
    }
    
    func columnCountGrid() ->Int {
        validate()
        return self.columnCount
    }
    func cellSizeGrid() ->CGSize {
        validate()
        return self.cellSize
    }
    
    
    func centerOfCell(row:Int, column:Int) ->CGPoint
    {
        var center:CGPoint = CGPointMake(self.cellSize.width/2, self.cellSize.height/2);
        var fColumn:CGFloat = CGFloat(column)
        var fRow:CGFloat = CGFloat(row)
        center.x += fColumn * self.cellSize.width
        center.y += fRow * self.cellSize.height
        return center
    }
    
    func frameOfCell(row:Int, column:Int) ->CGRect
    {
        var frame:CGRect = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
        var fColumn:CGFloat = CGFloat(column)
        var fRow:CGFloat = CGFloat(row)
        
        frame.origin.x += fColumn * self.cellSize.width;
        frame.origin.y += fRow * self.cellSize.height;
        return frame;
    }
    
    func description() ->String
    {
        var description:String  = "Grid fitting \(self.minimumNumberOfCells) cells with aspect ratio \(self.cellAspectRatio) into \(self.size)  "
        
        if self.rowCount <= 0 {
            description = description + "invalid input: "
            
            if self.minimumNumberOfCells == 0{ description = description + "minimumNumberOfCells = 0;"}
            if abs(self.cellAspectRatio)==0 {description = description + "cellAspectRatio = 0;"}
            if self.size.width == 0 {description = description + "size.width = 0;"}
            if self.size.height == 0 { description = description + "size.height = 0;"}
        } else {
            
            if self.minCellWidth == 0 || self.minCellHeight == 0 {
                description = description+"minimum width or height restricts grid to impossibility"}
            
        }
        
        return description;
        
    }
    
}
