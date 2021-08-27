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
    private var possibleSwaps: Set<Swap> = []

    func toy(atColumn column: Int, row: Int) -> Toy? {
      precondition(column >= 0 && column < totalColumns)
      precondition(row >= 0 && row < totalRows)

      return toys[column, row]
    }

    func shuffle() -> Set<Toy> {
        var set: Set<Toy>

        repeat {
            set = createInitialToys()
            detectPossibleSwaps()

            print("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0

        return set
    }

    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()

        removeToys(in: horizontalChains)
        removeToys(in: verticalChains)
        
        return horizontalChains.union(verticalChains)
    }

    func removeToys(in chains: Set<Chain>) {
        for chain in chains {
            for toy in chain.toys {
                toys[toy.column, toy.row] = nil
            }
        }
    }

    private func detectHorizontalMatches() -> Set<Chain> {
        var set: Set<Chain> = []

        for row in 0..<totalRows {
            var column = 0

            while column < totalColumns-2 {
                if let toy = toys[column, row] {
                    let matchType = toy.toyType

                    if toys[column + 1, row]?.toyType == matchType && toys[column + 2, row]?.toyType == matchType {
                        let chain = Chain(chainType: .horizontal)

                        repeat {
                            chain.add(toy: toys[column, row]!) // we are sure it exists
                            column += 1
                        } while column < totalColumns && toys[column, row]?.toyType == matchType

                        set.insert(chain)
                        continue
                    }
                }

                column += 1
            }
        }

        return set
    }

    private func detectVerticalMatches() -> Set<Chain> {
        var set: Set<Chain> = []

        for column in 0..<totalColumns {
            var row = 0

            while row < totalRows-2 {
                if let toy = toys[column, row] {
                    let matchType = toy.toyType

                    if toys[column, row + 1]?.toyType == matchType && toys[column, row + 2]?.toyType == matchType {
                        let chain = Chain(chainType: .vertical)

                        repeat {
                            chain.add(toy: toys[column, row]!) // we are sure it exists
                            row += 1
                        } while row < totalRows && toys[column, row]?.toyType == matchType

                        set.insert(chain)
                        continue
                    }
                }

                row += 1
            }
        }

        return set
    }

    func detectPossibleSwaps() {
        var set: Set<Swap> = []

        for row in 0..<totalRows {
            for column in 0..<totalColumns {
                if let toy = toys[column, row] {

                    // try swapping toy with the one on its right
                    if column < totalColumns - 1, let other = toys[column + 1, row] {
                        toys[column, row] = other
                        toys[column + 1, row] = toy

                        // check for chain
                        if hasChain(atColumn: column + 1, row: row) || hasChain(atColumn: column, row: row) {
                            set.insert(Swap(toyA: toy, toyB: other))
                        }

                        // swap back
                        toys[column, row] = toy
                        toys[column + 1, row] = other
                    }

                    // try swapping with toy above
                    if row < totalRows - 1, let other = toys[column, row + 1] {
                        toys[column, row] = other
                        toys[column, row + 1] = toy

                        // check for chain
                        if hasChain(atColumn: column, row: row + 1) || hasChain(atColumn: column, row: row) {
                            set.insert(Swap(toyA: toy, toyB: other))
                        }

                        // swap back
                        toys[column, row] = toy
                        toys[column, row + 1] = other
                    } else if column == totalColumns - 1, let toy = toys[column, row] {
                        // check swaps in last column
                        if row < totalRows - 1, let other = toys[column, row + 1] {
                            toys[column, row] = other
                            toys[column, row + 1] = toy

                           // check for chain
                            if hasChain(atColumn: column, row: row + 1) || hasChain(atColumn: column, row: row) {
                                set.insert(Swap(toyA: toy, toyB: other))
                            }

                            // swap back
                            toys[column, row] = toy
                            toys[column, row + 1] = other
                        }
                    }
                }
            }
        }

        possibleSwaps = set
    }

    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }

    private func hasChain(atColumn column: Int, row: Int) -> Bool {
        let toyType = toys[column, row]!.toyType

          // Horizontal chain check
          var horizontalLength = 1

          // Left
          var i = column - 1
          while i >= 0 && toys[i, row]?.toyType == toyType {
            i -= 1
            horizontalLength += 1
          }

          // Right
          i = column + 1
          while i < totalColumns && toys[i, row]?.toyType == toyType {
            i += 1
            horizontalLength += 1
          }
          if horizontalLength >= 3 { return true }

          // Vertical chain check
          var verticalLength = 1

          // Down
          i = row - 1
          while i >= 0 && toys[column, i]?.toyType == toyType {
            i -= 1
            verticalLength += 1
          }

          // Up
          i = row + 1
          while i < totalRows && toys[column, i]?.toyType == toyType {
            i += 1
            verticalLength += 1
          }

          return verticalLength >= 3
    }

    private func createInitialToys() -> Set<Toy> {
        var set: Set<Toy> = []

        for row in 0..<totalRows {
            for column in 0..<totalColumns {

                var toyType: ToyType

                // prevent random setup from creating any initial chains
                repeat {
                    toyType = ToyType.random()
                } while (column >= 2 && toys[column - 1, row]?.toyType == toyType && toys[column - 2, row]?.toyType == toyType) || (row >= 2 && toys[column, row - 1]?.toyType == toyType && toys[column, row - 2]?.toyType == toyType)

                let toy = Toy(column: column, row: row, toyType: toyType)
                toys[column, row] = toy

                set.insert(toy)
            }
        }

        return set
    }

    func performSwap(_ swap: Swap) {
        let columnA = swap.toyA.column
        let rowA = swap.toyA.row

        let columnB = swap.toyB.column
        let rowB = swap.toyB.row

        toys[columnA, rowA] = swap.toyB
        swap.toyB.column = columnA
        swap.toyB.row = rowA

        toys[columnB, rowB] = swap.toyA
        swap.toyA.column = columnB
        swap.toyA.row = rowB
    }

    func fillHoles() -> [[Toy]] {
        var columns: [[Toy]] = []

        for column in 0..<totalColumns {
            var array: [Toy] = []

            for row in 0..<totalRows {
                if toys[column, row] == nil {
                    for lookup in (row + 1)..<totalRows {
                        if let toy = toys[column, lookup] {
                            toys[column, lookup] = nil
                            toys[column, row] = toy
                            toy.row = row

                            array.append(toy)
                            break
                        }
                    }
                }
            }

            if !array.isEmpty {
                columns.append(array)
            }
        }

        return columns
    }

    func topUp() -> [[Toy]] {
        var columns: [[Toy]] = []
        var toyType: ToyType = .unknown

        for column in 0..<totalColumns {
            var array: [Toy] = []

            var row = totalRows - 1

            while row >= 0 && toys[column, row] == nil {
                var newToyType: ToyType

                repeat {
                    newToyType = ToyType.random()
                } while newToyType == toyType

                toyType = newToyType
                let toy = Toy(column: column, row: row, toyType: toyType)
                toys[column, row] = toy
                array.append(toy)

                row -= 1
            }

            if !array.isEmpty {
                columns.append(array)
            }
        }

        return columns
    }
}
