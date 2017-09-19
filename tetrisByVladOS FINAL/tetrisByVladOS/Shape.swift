//
//  Shape.swift
//  tetrisByVladOS
//
//  Created by air on 05.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import SpriteKit

let numOrintations: UInt32 = 4 //количество ориентаций

enum Orientation: Int, CustomStringConvertible
{
    case Zero=0,Ninety, OneEighty, TwoSeventy
    
    var description: String
    {
        switch self
        {
        case .Zero:
            return "0"
        case . Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    static func random()-> Orientation
    {
        return Orientation(rawValue: Int(arc4random_uniform(numOrintations)))!
    }
    static func rotate(orientation: Orientation,clockwise: Bool)->Orientation
    {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue
        {
            rotated = Orientation.Zero.rawValue
        }
        else if rotated<0
        {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

//количество форм 
let NumShapeTypes: UInt32 = 7

// индексы блоков из которых состоит фигура

let ZeroBlockIdx = 0
let FirstBlockIdx = 1
let SecondBlockIdx = 2
let ThirdBlockIdx = 3

class Shape: Hashable, CustomStringConvertible
{
    // цвет фигуры
    
    let color: BlockColor
    
    // блоки из которых состоит фигура
    
    var blocks = Array<Block>()
    
    //ориентация
    
    var orientation: Orientation
    
    //строка и столбец где находится фигура
    var column, row: Int
    
    //массив мап - позиция каждого блока из которого состоит фигура при определенной оринтации
    var blockRowColumnPosition: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]{
        return [:]
    }
    //массив мап - нижние блоки фигуры для каждой ориентации
    var bottomBlocksForOrientations: [Orientation: Array<Block>]
        {
        return [:]
    }
    //текущие нижние блоки
    var bottomBlocks: Array<Block>
        {
        guard let bottomBlocks = bottomBlocksForOrientations[orientation] else{
            return []
        }
        return bottomBlocks
        
    }
    
    var hashValue: Int{
        return blocks.reduce(0){$0.hashValue ^ $1.hashValue}
    }
    
    var description: String{
        return "\(color) block facing \(orientation): \(blocks[ZeroBlockIdx]), \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]))"
    }
    var name:String{
        return self.name
    }
    
    init (column: Int, row: Int, color: BlockColor, orientation: Orientation){
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    //вспомогательный инициализатор с рандомным цветом и ориентацией для фигуры
    convenience init (column: Int, row: Int){
        self.init(column: column, row: row, color: BlockColor.random(), orientation: Orientation.random())
    }
    
    func setBlockRowColumnPosition()->[Orientation:Array<(ColumnDiff:Int, RowDiif:Int)>]{
        return [
            Orientation.Zero: [(0,0),(0,1),(0,2),(1,2)],
            Orientation.Ninety: [(1,1),(0,1),(-1,1),(-1,2)],
            Orientation.OneEighty: [(0,2),(0,1),(0,0),(-1,0)],
            Orientation.TwoSeventy: [(-1,1),(0,1),(1,1),(1,0)]
        ]
    }
    static func ==(lhs: Shape, rhs: Shape)->Bool{
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    final func initializeBlocks(){
        guard let blockRowColumnTranslations = blockRowColumnPosition[orientation]else{
            return
        }
        //массив колонок и строчек позиции блоков каждый блок - колонка и строка фигуры+ее положение в строю
        blocks = blockRowColumnTranslations.map {(diff)->Block in
            return Block(column: column + diff.columnDiff, row: row + diff.rowDiff, color: color)
        }
    }
    
    final func rotateBlocks(orientation:Orientation){
        //получаем позиции блоков в ориентации которую приняли как аргумент
        guard let blockRowColumnTranslation:Array<(columnDiff: Int,rowDiff: Int)> = blockRowColumnPosition[orientation] else{
            return
        }
        //перебираем масив, enumerated позволяет получить индексы
        for(idx, diff) in blockRowColumnTranslation.enumerated(){
            blocks[idx].column=column+diff.columnDiff
            blocks[idx].row=row+diff.rowDiff
        }
    }
    
    final func rotateClockwise(){
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: true)
        rotateBlocks(orientation: newOrientation)
        orientation = newOrientation
    }
    
    final func rotateCounterClockwise(){
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: false)
        rotateBlocks(orientation: newOrientation)
        orientation = newOrientation
    }
    
    //опускае фигуру на одну строку
    final func lowerShapeByOneRow(){
        shiftBy(columns:0,rows:1)
    }
    
    final func raiseShapeByOneRow(){
        shiftBy(columns: 0, rows: -1)
    }
    
    final func shiftRightByOneColumn(){
        shiftBy(columns: 1, rows: 0)
    }
    
    final func shiftLeftByOneColumn(){
        shiftBy(columns: -1, rows: 0)
    }
    
    final func shiftBy(columns: Int,rows: Int){
        self.column+=columns
        self.row+=rows
        for block in blocks{
            block.column+=columns
            block.row+=rows
        }
    }
    
    final func moveTo(column: Int, row: Int){
        self.column=column
        self.row=row
        rotateBlocks(orientation: orientation)
    }
    
    final class func random(startingColumn: Int,startingRow:Int)->Shape{
        switch Int(arc4random_uniform(NumShapeTypes)){
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        case 1:
            return LineShape(column: startingColumn, row: startingRow)
        case 2:
            return TShape(column: startingColumn, row: startingRow)
        case 3:
            return LShape(column: startingColumn, row: startingRow)
        case 4:
            return JShape(column: startingColumn, row: startingRow)
        case 5:
            return SShape(column: startingColumn, row: startingRow)
        default:
            return ZShape(column: startingColumn, row: startingRow)
        }
    }
}






