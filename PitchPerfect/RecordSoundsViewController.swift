//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Adis Cehajic on 05/04/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: RecordSoundsViewController

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
        
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Constants
    
    struct RecordSoundsConstants {
        static let StopRecordingIdentifier = "stopRecording"
        static let RecordSoundText = "Tap to Record!"
        static let RecordingSoundText = "Recording!"
    }
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == RecordSoundsConstants.StopRecordingIdentifier {
            // Initialize play sounds view controller and set url
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: Recoding audio methods

    @IBAction func recordAudio(_ sender: Any) {
        
        setupUI(.playing)
        
        // Set location where to save audio file.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        // Initialize audio recorder and start recording audio.
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        
        setupUI(.notPlaying)
        
        // Stop recording audio.
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Private methods
    
    func setupUI(_ playingState: PlayingState) {
        switch playingState {
        case .notPlaying:
            recordingLabel.text = RecordSoundsConstants.RecordSoundText
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            
            // Animate when the stop recording button is disappearing.
            UIView.animate(withDuration: 0.3) {
                self.stopRecordingButton.alpha = 0.0
            }
            break
        case .playing:
            recordingLabel.text = RecordSoundsConstants.RecordingSoundText
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            
            // Animate when the stop recording button is appearing.
            UIView.animate(withDuration: 0.3) {
                self.stopRecordingButton.alpha = 1.0
            }
            break
        }
    }
    
}

// MARK: RecordSoundsViewController : AVAudioRecorderDelegate

extension RecordSoundsViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: RecordSoundsConstants.StopRecordingIdentifier, sender: audioRecorder.url)
        } else {
            print("Recording was not successfull")
        }
    }
    
}

