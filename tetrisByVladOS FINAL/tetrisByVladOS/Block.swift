//
//  Block.swift
//  tetrisByVladOS
//
//  Created by air on 05.10.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

import SpriteKit

let numberOfColors: UInt32 = 6 // количество цветов

enum BlockColor: Int, CustomStringConvertible // перечисление
{
    case Blue = 0, Orange, Purple, Red, DarkBlue, Yellow
    
    var spriteName: String
    {
        switch self
        {
        case.Blue:
            return "blue"
        case.Orange:
            return "orange"
        case.Purple:
            return "purple"
        case.Red:
            return "red"
        case.DarkBlue:
            return "darkBlue"
        case.Yellow:
            return "yellow"
            
        }
        
    }
    var description: String
    {
        return self.spriteName
    }
    static func random()->BlockColor
    {
        return BlockColor(rawValue: Int(arc4random_uniform(numberOfColors)))!
    }
}

class Block: Hashable, CustomStringConvertible
{
    let color: BlockColor // цвет блока
    
    var column: Int //колонка
    var row: Int //строка
    
    var sprite: SKSpriteNode?
    var shadow: SKSpriteNode?
    var spriteName: String
    {
        return color.spriteName
    }
    var hashValue: Int
    {
        return self.column ^ self.row
    }
    var description: String
    {
        return ("\(color):[\(column),\(row)] ")
    }
    init(column: Int, row: Int, color: BlockColor)
    {
        self.column=column
        self.row=row
        self.color=color
        
    }
    static func ==(lhs: Block, rhs: Block)->Bool
    {
        return lhs.column==rhs.column && lhs.row==rhs.row && lhs.color.rawValue==rhs.color.rawValue
    }
}

