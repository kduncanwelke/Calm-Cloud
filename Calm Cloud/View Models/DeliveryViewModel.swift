//
//  DeliveryViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/4/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

public class DeliveryViewModel {

    var selected: Plant?
    var number = 0

    func randomSeeds() -> String {
        let random = Int.random(in: 0...38)
        let type = Plant(rawValue: random)
        selected = type

        // if single pot plant only give one seedling
        if random == 3 || random == 5 || random == 6 || random == 10 || random == 18 || random == 26 || random == 27 || random == 28 || random == 29 || random == 30 || random == 31 {
            number = 1
        } else {
            number = Int.random(in: 1...2)
        }

        add()

        let name = getName()

        return "x\(number) \(name) Seedlings"
    }

    func add() {
        guard let chosen = selected else { return }

        if let plantCount = Plantings.availableSeedlings[chosen] {
            Plantings.availableSeedlings[chosen] = plantCount + number
        }

        DataFunctions.saveInventory()
    }

    func getName() -> String {
        switch selected {
        case .chard:
            return "Rainbow Chard"
        case .geranium:
            return "Pink Geranium"
        case .jade:
            return "Jade"
        case .lemon:
            return "Lemon Tree"
        case .pumpkin:
            return "Pumpkin"
        case .redTulip:
            return "Red Tulip"
        case .redGeranium:
            return "Red Geranium"
        case .yellowTulip:
            return "Yellow Tulip"
        case .carrot:
            return "Carrot"
        case .lime:
            return "Lime Tree"
        case .pinkTulip:
            return "Pink Tulip"
        case .squash:
            return "Summer Squash"
        case .strawberry:
            return "Strawberry"
        case .watermelon:
            return "Watermelon"
        case .whiteTulip:
            return "White Tulip"
        case .pepper:
            return "Bell Pepper"
        case .cherryTomato:
            return "Cherry Tomato"
        case .kale:
            return "Kale"
        case .daffodil:
            return "Daffodil"
        case .orange:
            return "Orange Tree"
        case .zinnia:
            return "Fuchsia Zinnia"
        case .lavendarZinnia:
            return "Lavendar Zinnia"
        case .salmonZinnia:
            return "Salmon Zinnia"
        case .aloe:
            return "Tiger Aloe"
        case .paddle:
            return "Paddle Plant"
        case .marigold:
            return "Marigold"
        case .lobelia:
            return "Lobelia"
        case .daisy:
            return "Daisy"
        case .cauliflower:
            return "Cauliflower"
        case .purplePetunia:
            return "Purple Petunia"
        case .whitePetunia:
            return "White Petunia"
        case .stripedPetunia:
            return "Striped Petunia"
        case .blackPetunia:
            return "Black Petunia"
        case .bluePetunia:
            return "Blue Petunia"
        case .eggplant:
            return "Eggplant"
        case .beans:
            return "Beans"
        case .corn:
            return "Corn"
        case .sunflower:
            return "Sunflower"
        case .tomato:
            return "Tomato"
        default:
            return ""
        }
    }
}
