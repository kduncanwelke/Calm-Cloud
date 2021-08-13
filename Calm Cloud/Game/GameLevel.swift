//
//  GameLevel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/5/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

let totalColumns = 9
let totalRows = 9

class GameLevel {

    private var toys = Array2D<Toy>(columns: totalColumns, rows: totalRows)

    func toy(atColumn column: Int, row: Int) -> Toy? {
      precondition(column >= 0 && column < totalColumns)
      precondition(row >= 0 && row < totalRows)

      return toys[column, row]
    }

    func shuffle() -> Set<Toy> {
        return createInitialToys()
    }

    private func createInitialToys() -> Set<Toy> {
        var set: Set<Toy> = []

        for row in 0..<totalRows {
            for column in 0..<totalColumns {

              let toyType = ToyType.random()

              let toy = Toy(column: column, row: row, toyType: toyType)
              toys[column, row] = toy

              set.insert(toy)
            }
          }

          return set
    }
}
