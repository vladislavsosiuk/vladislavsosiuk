//
//  Array.swift
//  tetrisByVladOS
//
//  Created by air on 30.09.16.
//  Copyright © 2016 VladOS. All rights reserved.
//

class SelfArray<T> //шаблонный класс 
{
    let columns: Int
    let raws: Int
    
    var array: Array<T?>
    
    init(columns: Int, raws: Int)
    {
        self.columns=columns
        self.raws=raws
        array = Array<T?>(repeating: nil, count: (raws*columns))
    }
    subscript(column: Int, raw: Int)->T?//геттер и сеттер
    {
        get
        {
            return array[(raw*columns)+column]
        }
        set(newValue)
        {
            array[(raw*columns)+column]=newValue
        }
    }
}
