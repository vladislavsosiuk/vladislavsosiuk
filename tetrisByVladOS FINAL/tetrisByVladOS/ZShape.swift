//
//  ZShape.swift
//  tetrisByVladOS
//
//  Created by air on 18.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import Foundation
class ZShape: Shape {
    /*
     -|0|
    |2|1|
    |3|
 
    |0 |1-|
       |2 |3 |*/
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return[
            Orientation.Zero: [(1,0),(1,1),(0,1),(0,2)],
            Orientation.Ninety: [(-1,0),(0,0),(0,1),(1,1)],
            Orientation.OneEighty: [(1,0),(1,1),(0,1),(0,2)],
            Orientation.TwoSeventy: [(-1,0),(0,0),(0,1),(1,1)]
        ]
    }
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return [
            Orientation.Zero: [blocks[FirstBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.Ninety: [blocks[ZeroBlockIdx],blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.OneEighty: [blocks[FirstBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: [blocks[ZeroBlockIdx],blocks[SecondBlockIdx],blocks[ThirdBlockIdx]]
            
        ]
    }
    override var name: String{
        return "ZShape"
    }
}
