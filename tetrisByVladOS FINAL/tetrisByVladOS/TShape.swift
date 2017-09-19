//
//  TShape.swift
//  tetrisByVladOS
//
//  Created by air on 06.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

class TShape: Shape{
    /*
     Orientatio 0: 
       -|0|
      |1|2|3|
     Orientation 90:
     -|1|
      |2|0|
      |3|
     Orientation 180:
      -
     |1|2|3|
       |0|
     Orientation 270:
         -|1|
        |0|2|
          |3|
     "-" - индикатор относительно которого строится фигура
 */
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return[
            Orientation.Zero: [(1,0),(0,1),(1,1),(2,1)],
            Orientation.Ninety: [(2,1),(1,0),(1,1),(1,2)],
            Orientation.OneEighty: [(1,2),(0,1),(1,1),(2,1)],
            Orientation.TwoSeventy: [(0,1),(1,0),(1,1),(1,2)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return[
            Orientation.Zero: [blocks[FirstBlockIdx],blocks[SecondBlockIdx], blocks[ThirdBlockIdx]],
            Orientation.Ninety: [blocks[ZeroBlockIdx], blocks[ThirdBlockIdx]],
            Orientation.OneEighty: [blocks[ZeroBlockIdx],blocks[FirstBlockIdx], blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: [blocks[ZeroBlockIdx],blocks[ThirdBlockIdx]]
        ]
    }
    override var name: String{
        return "TShape"
    }
}
