//
//  JShape.swift
//  tetrisByVladOS
//
//  Created by air on 18.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import Foundation

class JShape:Shape{
    /*
    -|0|
     |1|
   |3|2|
 
    |3-|
    |2 |1|0|
 
    |2-|3|
    |1|
    |0|
 
    |0-|1|2|
         |3|*/
    
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return[
            Orientation.Zero: [(1,0),(1,1),(1,2),(0,2)],
            Orientation.Ninety: [(2,1),(1,1),(0,1),(0,0)],
            Orientation.OneEighty: [(0,2),(0,1),(0,0),(1,0)],
            Orientation.TwoSeventy: [(0,0),(1,0),(2,0),(2,1)]
        ]
    }
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return[
            Orientation.Zero: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.Ninety: [blocks[ZeroBlockIdx],blocks[FirstBlockIdx],blocks[SecondBlockIdx]],
            Orientation.OneEighty: [blocks[ZeroBlockIdx], blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: [blocks[ZeroBlockIdx],blocks[FirstBlockIdx],blocks[ThirdBlockIdx]]
        ]
    }
    override var name: String{
        return "JShape"
    }
}
