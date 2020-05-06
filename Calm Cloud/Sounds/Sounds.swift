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
    static let calmMusic = Sound(resourceName: "audio_hero_NightAmbienceCalm+PE011801", type: "mp3")
}

// sound by Audio Hero on Zapsplat
