//
//  SquareShape.swift
//  tetrisByVladOS
//
//  Created by air on 06.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

class SquareShape: Shape{
    /*
    |0-|1|
    |2 |3|
     "-" - индикатор относительно которого строится фигура
 */
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Zero:[(0,0),(1,0),(0,1),(1,1)],
            Orientation.Ninety:[(0,0),(1,0),(0,1),(1,1)],
            Orientation.OneEighty:[(0,0),(1,0),(0,1),(1,1)],
            Orientation.TwoSeventy:[(0,0),(1,0),(0,1),(1,1)]
        ]
    }
    override var bottomBlocksForOrientations: [Orientation : Array<Block>]{
        return [
            Orientation.Zero: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.Ninety: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.OneEighty: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.TwoSeventy: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx]]
        ]
    }
    override var name: String{
        return "SquareShape"
    }
}


