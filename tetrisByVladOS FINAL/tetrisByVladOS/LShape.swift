//
//  LShape.swift
//  tetrisByVladOS
//
//  Created by air on 06.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

class LShape:Shape{
    /*
    |0-|
    |1 |
    |2 |3 |
 
        -
    |2 |1 |0 |
    |3 |
 
    |3 |2-|
       |1 |
       |0 |
 
       -|3|
    |0|1|2|
 */
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero: [(0,0),(0,1),(0,2),(1,2)],
            Orientation.Ninety: [(1,1),(0,1),(-1,1),(-1,2)],
            Orientation.OneEighty: [(0,2),(0,1),(0,0),(-1,0)],
            Orientation.TwoSeventy: [(-1,1),(0,1),(1,1),(1,0)]
        ]
    }
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return [
            Orientation.Zero: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.Ninety: [blocks[ZeroBlockIdx],blocks[FirstBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.OneEighty: [blocks[ZeroBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: [blocks[ZeroBlockIdx],blocks[FirstBlockIdx],blocks[SecondBlockIdx]]
        ]
    }
    override var name: String{
        return "LShape"
    }
}
