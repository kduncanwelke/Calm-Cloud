//
//  LevelData.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/30/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

class LevelData: Codable {
    let tiles: [[Int]]
    let targetScore: Int
    let moves: Int

    static func loadFrom(file filename: String) -> LevelData? {
        var data: Data
        var levelData: LevelData?

        if let path = Bundle.main.url(forResource: filename, withExtension: "json") {
            do {
                data = try Data(contentsOf: path)
            } catch {
                print("file failed to load")
                return nil
            }

            do {
                levelData = try JSONDecoder().decode(LevelData.self, from: data)
            } catch {
                print("could not decode file")
                return nil
            }
        }

        return levelData
    }
}
