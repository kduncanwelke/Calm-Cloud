//
//  Sounds.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/6/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    var resourceName: String
    var type: String
    
    init(resourceName: String, type: String) {
        self.resourceName = resourceName
        self.type = type
    }
    
    static var calmMusicPlayer: AVAudioPlayer?
    
    static func loadSound(resourceName: String, type: String) {
        let path = Bundle.main.path(forResource: resourceName, ofType: type)
        let soundURL = URL(fileURLWithPath: path!)
       
        do {
            calmMusicPlayer = try AVAudioPlayer(contentsOf: soundURL)
            calmMusicPlayer?.numberOfLoops = -1
        } catch {
            print("could not load file")
        }
    }
    
    static func startPlaying() {
        calmMusicPlayer?.play()
    }
    
    static func stopPlaying() {
        calmMusicPlayer?.stop()
    }
    
}

struct Sounds {
    static let night = Sound(resourceName: "audio_hero_NightAmbienceCalm+PE011801", type: "mp3")
    static let outside = Sound(resourceName: "audio_hero_ForestDay_DIGIX05_11_362", type: "mp3")
    static let inside = Sound(resourceName: "tspt_city_spring_indoor_ambience_loop_019", type: "mp3")
    static let music = Sound(resourceName: "loire", type: "mp3")
}

// Night Ambience and Forest Ambience by Audio Hero on Zapsplat
// Indoor Ambience by The Sound Pack Tree

// Loire and You Will Know by Taylor Howard on Zapsplat
