//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Adis Cehajic on 08/04/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: PlayingState (raw values correspond to sender tags)

enum PlayingState {
    case playing,
    notPlaying
}

// MARK: PlaySoundsViewController

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // MARK: Button types
    
    enum ButtonType: Int {
        case slow = 0,
        fast,
        chipmunk,
        vader,
        echo,
        reverb
    }
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup audio file with passed recorded file url.
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set appearance of the view.
        configureUI(.notPlaying)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // If going back stop playing audio.
        stopAudio()
    }

    // MARK: Play audio methods
    
    @IBAction func playSoundForAction(_ sender: UIButton) {
        
        // Play corresponding sound for pressed button.
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
            break
        case .fast:
            playSound(rate: 1.5)
            break
        case .chipmunk:
            playSound(pitch: 1000)
            break
        case .vader:
            playSound(pitch: -1000)
            break
        case .echo:
            playSound(echo: true)
            break
        case .reverb:
            playSound(reverb: true)
            break
        }
        // Set appearance of the view.
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        
        // Stop playing audio.
        stopAudio()
    }
    
}
