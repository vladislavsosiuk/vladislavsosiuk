//
//  SShape.swift
//  tetrisByVladOS
//
//  Created by air on 18.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import Foundation
class SShape:Shape{
    /*
    |0-|
    |1 |2 |
       |3 |
 
    -|1|0|
   |3|2|
 
    |0-|
    | 1|2 |
       |3 |
 
    -|1|0|
   |3|2|*/
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return[
            Orientation.Zero: [(0,0),(0,1),(1,1),(1,2)],
            Orientation.Ninety: [(2,0),(1,0),(1,1),(0,1)],
            Orientation.OneEighty: [(0,0),(0,1),(1,1),(1,2)],
            Orientation.TwoSeventy:[(2,0),(1,0),(1,1),(0,1)]
        ]
    }
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return[
            Orientation.Zero: [blocks[FirstBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.Ninety: [blocks[ZeroBlockIdx],blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.OneEighty: [blocks[FirstBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: [blocks[ZeroBlockIdx],blocks[SecondBlockIdx],blocks[ThirdBlockIdx]]
        ]
    }
    override var name: String{
        return "SShape"
    }
}
