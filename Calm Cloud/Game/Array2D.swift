//
//  Array2D.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/12/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

class Array2D<T> {

    let columns: Int
    let rows: Int

    private var array: Array<T?>

    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }

    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }

        set {
            array[row*columns + column] = newValue
        }
    }
}
