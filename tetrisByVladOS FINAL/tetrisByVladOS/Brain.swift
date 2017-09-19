//
//  Brain.swift
//  tetrisByVladOS
//
//  Created by air on 18.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 1

let PreviewColumn = 12
let PreviewRow = 1

let PointsPerLine = 10
let LevelThreshold = 100

protocol BrainDelegate {
    func gameDidEnd(brain: Brain)
    func gameDidBegin(brain: Brain)
    func gameShapeDidLand(brain: Brain)
    func gameShapeDidMove(brain: Brain)
    func gameShapeDidDrop(brain: Brain)
    func gameDidLevelUp(brain: Brain)
}

class Brain{
    var blockArray: SelfArray<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    var shadowShape:Shape?
    var delegate: BrainDelegate?
    var score = 0
    var level = 1
    init(){
        fallingShape = nil
        nextShape = nil
        shadowShape=nil
        blockArray = SelfArray<Block>(columns: NumColumns, raws:NumRows)
    }
    
    func beginGame(){
        if nextShape == nil{
            nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        }
        delegate?.gameDidBegin(brain: self)
    }
    
    func newShape()->(fallingShape:Shape?,nextShape:Shape?){
        fallingShape = nextShape
        nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(column: StartingColumn, row: StartingRow)
        switch fallingShape!.name{
        case "LShape":
            shadowShape = LShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
        case "JShape":
            shadowShape = JShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
        case "SShape":
            shadowShape = SShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
        case "ZShape":
            shadowShape = ZShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
        case "SquareShape":
            shadowShape = SquareShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
        case "TShape":
            shadowShape = TShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
        default:
            shadowShape = LineShape(column: (fallingShape?.column)!, row: (fallingShape?.row)!, color: (fallingShape?.color)!, orientation: (fallingShape?.orientation)!)
            
        }
        guard detectIllegalPlacement()==false else{
            nextShape = fallingShape
            nextShape!.moveTo(column: PreviewColumn, row: PreviewRow)
            endGame()
            return (nil,nil)
        }
        shadowPos()
        
        return(fallingShape, nextShape)
    }
    func shadowPos(){
        for (block, realBlock) in zip((shadowShape?.blocks)!,(fallingShape?.blocks)!){
            block.row=realBlock.row
        }
        while !detectShadowTouch(){
            for block in (shadowShape?.blocks)!{
                block.row+=1
            }
            if detectShadowIllegalPlacement(){
                break
            }
        }
    }
    func detectShadowIllegalPlacement()->Bool{
        guard let shape = shadowShape else{
            return false
        }
        for block in shape.blocks{
            if block.column<0 || block.column>=NumColumns || block.row<0 || block.row >= NumRows{
                return true
            }else if blockArray[block.column,block.row] != nil{
                return true
            }
        }
        return false
    }
    func detectIllegalPlacement()->Bool{
        guard let shape = fallingShape else{
            return false
        }
        for block in shape.blocks{
            if block.column<0 || block.column>=NumColumns || block.row<0 || block.row >= NumRows{
                return true
            }else if blockArray[block.column,block.row] != nil{
                return true
            }
        }
        return false
    }
    func detectShadowTouch()->Bool{
        guard let shape = shadowShape else{
            return false
        }
        for bottomBlock in shape.bottomBlocks{
            if bottomBlock.row == NumRows-1 || blockArray[bottomBlock.column, bottomBlock.row+1] != nil{
                return true
            }
        }
        return false
    }
    func detectTouch()->Bool{
        guard let shape = fallingShape else{
            return false
        }
        for bottomBlock in shape.bottomBlocks{
            if bottomBlock.row == NumRows-1 || blockArray[bottomBlock.column, bottomBlock.row+1] != nil{
                return true
            }
        }
        return false
    }
    
    func dropShape(){
        guard let shape = fallingShape else{
            return
        }
        while detectIllegalPlacement() == false{
            shape.lowerShapeByOneRow()
        }
        shape.raiseShapeByOneRow()
        delegate?.gameShapeDidDrop(brain: self)
    }
    
    func letshapeFall(){
        guard let shape = fallingShape else{
            return
        }
        shape.lowerShapeByOneRow()
        if detectIllegalPlacement(){
            shape.raiseShapeByOneRow()
            if detectIllegalPlacement(){
                endGame()
            }else{
                settleShape()
            }
        }else{
            delegate?.gameShapeDidMove(brain: self)
            if detectTouch(){
                settleShape()
            }
        }
    }
    func rotateShape(){
        guard let shape = fallingShape else{
            return
        }
        let shadow = shadowShape
        
        shape.rotateClockwise()
        guard detectIllegalPlacement() == false else{
            shape.rotateCounterClockwise()
            return
        }
        
        shadow?.rotateClockwise()
        shadowPos()
        delegate?.gameShapeDidMove(brain: self)
    }
    func moveShapeLeft(){
        guard let shape = fallingShape else{
            return
        }
        let shadow = shadowShape
        shape.shiftLeftByOneColumn()
        guard detectIllegalPlacement() == false else{
            shape.shiftRightByOneColumn()
            return
        }
        shadow?.shiftLeftByOneColumn()
        shadowPos()
        delegate?.gameShapeDidMove(brain: self)
    }
    func moveShapeRight(){
        guard let shape = fallingShape else{
            return
        }
        let shadow = shadowShape
        shape.shiftRightByOneColumn()
        guard detectIllegalPlacement() == false else{
            shape.shiftLeftByOneColumn()
            return
        }
        shadow?.shiftRightByOneColumn()
        shadowPos()
        delegate?.gameShapeDidMove(brain: self)
    }
    func settleShape(){
        guard let shape = fallingShape else{
            return
        }
        for block in shape.blocks{
            blockArray[block.column,block.row] = block
        }
        fallingShape = nil
        delegate?.gameShapeDidLand(brain: self)
    }
    
    func endGame(){
        score = 0
        level = 1
        delegate?.gameDidEnd(brain: self)
    }
    func removeCompletedLines()->(linesRemoved: Array<Array<Block>>,fallenBlocks: Array<Array<Block>>){
        var removedLines = Array<Array<Block>>()
        for row in(1..<NumRows).reversed(){
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns{
                guard let block = blockArray[column,row] else {
                    continue
                }
                rowOfBlocks.append(block)
            }
            if rowOfBlocks.count == NumColumns{
                removedLines.append(rowOfBlocks)
                for block in rowOfBlocks{
                    blockArray[block.column, block.row] = nil
                }
            }
        }
        if removedLines.count == 0{
            return ([],[])
        }
        let pointsEarned = removedLines.count * PointsPerLine * level
        score+=pointsEarned
        if score>=level*LevelThreshold{
            level+=1
            delegate?.gameDidLevelUp(brain: self)
        }
        var fallenBlocks = Array<Array<Block>>()
        for column in 0..<NumColumns{
            var fallenBlocksArray = Array<Block>()
            for row in (1..<removedLines[0][0].row).reversed(){
                guard let block = blockArray[column,row] else {
                    continue
                }
                var newRow = row
                while (newRow < NumRows - 1 && blockArray[column,newRow+1] == nil){
                    newRow += 1
                }
                block.row = newRow
                blockArray[column,row] = nil
                blockArray[column,newRow] = block
                fallenBlocksArray.append(block)
            }
            if fallenBlocksArray.count>0{
                fallenBlocks.append(fallenBlocksArray)
            }
        }
        return (removedLines,fallenBlocks)
    }
    func removeAllBlocks()->Array<Array<Block>>{
        var allBlocks = Array<Array<Block>>()
        for row in 0..<NumRows{
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns{
                guard let block = blockArray[column,row] else {
                    continue
                }
                rowOfBlocks.append(block)
                blockArray[column,row] = nil
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }
}
