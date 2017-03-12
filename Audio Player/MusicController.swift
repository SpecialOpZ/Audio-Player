//  ViewController.swift
//  Audio Player
//
//  Created by Anthony on 5/19/16.
//  Copyright © 2016 appalgorithm. All rights reserved.

import UIKit
import AVFoundation

class MusicController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var musicTable: UITableView!
    @IBOutlet weak var trackNameDisplayLabel: UILabel!
    @IBOutlet weak var artistNameDisplayLabel: UILabel!
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var volumeDisplayLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var scrubberSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var index:IndexPath!
    var musicPlayer:AVAudioPlayer!
    var timer:Timer!
    var isPlaying = false
    var musicArray:[String] = ["Arcade", "Beat Down", "Crank it up", "Dubday", "Live forever", "Man up", "Ski Chalet", "The Calvary", "The Winner", "Trap to the future"]
    
    var titleData:String!
    var artistData:String!
    var audioDurationSeconds:Double!
    
    //var asset:AVAsset!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_BLUE_COLOR
        musicTable.delegate = self
        musicTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
//MARK: - Music Player setup
    //1
    func playSong() {
        configureMusicPlayer(musicArray[index.row])
        scrubberSlider.value = 0
        scrubberSlider.maximumValue = Float(musicPlayer.duration)
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(MusicController.updateTimer), userInfo: nil, repeats: true)
    }
    
    //2
    func configureMusicPlayer(_ song:String) {
        let path = Bundle.main.path(forResource: song, ofType: "mp3")
        let urlForSounds = URL(fileURLWithPath: path!)
        let asset = AVAsset(url: urlForSounds) as AVAsset
        
        for metaDataItems in asset.commonMetadata {
            if metaDataItems.commonKey == "title" {
                titleData = String(describing: metaDataItems.value!)
                trackNameDisplayLabel.text = titleData
            }
            if metaDataItems.commonKey == "artist" {
                artistData = String(describing: metaDataItems.value!)
                artistNameDisplayLabel.text = artistData
            }
        }
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: urlForSounds)
            musicPlayer.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        musicPlayer.play()
    }
    
    //3
    func updateTimer() {
        let currentTime = Int(musicPlayer.currentTime)
        let minutes = currentTime / 60
        let seconds = currentTime - minutes * 60
        timeDisplayLabel.text = String(format: "%02i:%02i", minutes, seconds)
        scrubberSlider.value = Float(musicPlayer.currentTime)
    }
    
//MARK: - TableView Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MusicCell
        let path = Bundle.main.path(forResource: musicArray[indexPath.row], ofType: "mp3")
        let urlForSounds = URL(fileURLWithPath: path!)
        let asset = AVAsset(url: urlForSounds) as AVAsset
        
        for metaDataItems in asset.commonMetadata {
            if metaDataItems.commonKey == "artist" {
                artistData = String(describing: metaDataItems.value!)
            }
        }
        
        cell.updateCell(musicArray[indexPath.row], artist: artistData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = tableView.indexPathForSelectedRow
        playSong()
    }

//MARK: - Buttons
    @IBAction func scrubberWasMoved(_ sender: UISlider) {
        musicPlayer.stop()
        musicPlayer.currentTime = TimeInterval(scrubberSlider.value)
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    
    @IBAction func volumeWasMoved(_ sender: UISlider) {
        if musicPlayer != nil {
            musicPlayer.volume = volumeSlider.value
        } else {
            print(volumeSlider.value)
        }
        volumeDisplayLabel.text = "\(Int(floor(volumeSlider.value * 100))) %"
    }
 
    @IBAction func pauseButtonPressed(_ sender: UIBarButtonItem) {
        musicPlayer.pause()
    }
    
    @IBAction func playButtonPressed(_ sender: UIBarButtonItem) {
        if musicPlayer == nil {
            configureMusicPlayer(musicArray[0])
        } else {
            musicPlayer.play()
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        musicPlayer.stop()
        scrubberSlider.value = 0
        musicPlayer.currentTime = 0
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

