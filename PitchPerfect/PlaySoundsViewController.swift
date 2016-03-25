//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Adam Zarn on 3/13/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    func stopAllAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
    }
    
    func startPlaybackAtSpeedOf(playbackSpeed: Float) {
        stopAllAudio()
        audioPlayer.rate = playbackSpeed
        audioPlayer.play()
    }
    
    func startPlaybackWithNewEffectOf(pitch: Float, echo: Float, reverb: Float) {
        //some of this function I found on GitHub
        stopAllAudio()
        let pitchPlayer = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        let echoEffect = AVAudioUnitDelay()
        let reverbEffect = AVAudioUnitReverb()
        timePitch.pitch = pitch
        echoEffect.delayTime = NSTimeInterval(echo)
        reverbEffect.wetDryMix = reverb
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        audioEngine.attachNode(echoEffect)
        audioEngine.attachNode(reverbEffect)
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        pitchPlayer.play()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        startPlaybackAtSpeedOf(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        startPlaybackAtSpeedOf(2.0)
    }

    @IBAction func playChipmunk(sender: UIButton) {
        startPlaybackWithNewEffectOf(1000,echo:0,reverb:0)
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        startPlaybackWithNewEffectOf(-1000,echo:0,reverb:0)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        startPlaybackWithNewEffectOf(0,echo:0.2,reverb:0)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        startPlaybackWithNewEffectOf(0,echo:0,reverb:50.0)
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        stopAllAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer =  try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}