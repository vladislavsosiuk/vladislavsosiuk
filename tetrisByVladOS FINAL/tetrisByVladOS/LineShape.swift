//
//  LineShape.swift
//  tetrisByVladOS
//
//  Created by air on 06.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

class LineShape: Shape{
    /*
    |0-|
    |1 |
    |2 |
    |3 |
 
    |0 |1-|2 |3 |
     "-" - индикатор относительно которого строится фигура
 */
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(0,0),(0,1),(0,2),(0,3)],
            Orientation.Ninety: [(-1,0),(0,0),(1,0),(2,0)],
            Orientation.OneEighty:[(0,0),(0,1),(0,2),(0,3)],
            Orientation.TwoSeventy: [(-1,0),(0,0),(1,0),(2,0)]
        ]
    }
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return[
            Orientation.Zero: [blocks[ThirdBlockIdx]],
            Orientation.Ninety: blocks,
            Orientation.OneEighty: [blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: blocks
        ]
    }
    override var name: String{
        return "LineShape"
    }
}
