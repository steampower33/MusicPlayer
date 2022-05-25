//
//  MediaPlayer.swift
//  SpotifyClone
//
//  Created by SeungMin Lee on 2022/05/24.
//

import UIKit
import AVKit

final class MediaPlayer: UIView {
    var album: Album
    
    private lazy var albumCover: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 10
        return v
    }()
    
//    private lazy var thumbView: UIView = {
//        let thumb = UIView()
//        thumb.backgroundColor = .yellow//thumbTintColor
//        thumb.layer.borderWidth = 0.4
//        thumb.layer.borderColor = UIColor.darkGray.cgColor
//        return thumb
//    }()
    
    private lazy var progressBar: UISlider = {
        let v = UISlider()
        v.translatesAutoresizingMaskIntoConstraints = false
//        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(5))
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .light)
        v.setThumbImage(UIImage(systemName: "circle.fill", withConfiguration: config), for: .normal)
        v.thumbTintColor = UIColor.white
        v.addTarget(self, action: #selector(progressScrubbed(_:)), for: .valueChanged)
        v.minimumTrackTintColor = UIColor(named: "subtitleColor")
        return v
    }()

    private lazy var elapsedTimeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 12, weight: .light)
        v.text = "00:00"
        return v
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 12, weight: .light)
        v.text = "00:00"
        return v
    }()
    
    private lazy var songNameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 20, weight: .bold)
        return v
    }()
    
    private lazy var artistLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 20, weight: .light)
        return v
    }()
    
    private lazy var previousButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        v.setImage(UIImage(systemName: "backward.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        v.tintColor = .white
        return v
    }()
    
    private lazy var playPauseButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        v.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapPlayPause(_:)), for: .touchUpInside)
        v.tintColor = .white
        return v
    }()
    
    private lazy var nextButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        v.setImage(UIImage(systemName: "forward.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        v.tintColor = .white
        return v
    }()
    
    private lazy var controlStack: UIStackView = {
       let v = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.distribution = .equalSpacing
        v.spacing = 20
        return v
    }()
    
    private lazy var minVolume: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        v.setImage(UIImage(systemName: "speaker.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapMinVolume(_:)), for: .touchUpInside)
        v.tintColor = UIColor(named: "subtitleColor")
        return v
    }()
    
    private lazy var maxVolume: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        v.setImage(UIImage(systemName: "speaker.wave.3.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapMaxVolume(_:)), for: .touchUpInside)
        v.tintColor = UIColor(named: "subtitleColor")
        return v
    }()
    
    private lazy var volumeBar: UISlider = {
        let v = UISlider()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(volumeScrubbed(_:)), for: .valueChanged)
        v.minimumTrackTintColor = UIColor(named: "subtitleColor")
        v.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        v.thumbTintColor = UIColor.white
        return v
    }()
    
    private lazy var volumeStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [minVolume, volumeBar, maxVolume])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.spacing = 15
        return v
    }()
    
    private lazy var lyricButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        v.setImage(UIImage(systemName: "text.bubble.fill", withConfiguration: config), for: .normal)
        v.tintColor = UIColor(named: "subtitleColor")
        return v
    }()
    
    private lazy var airPlayButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        v.setImage(UIImage(systemName: "airplayaudio", withConfiguration: config), for: .normal)
        v.tintColor = UIColor(named: "subtitleColor")
        return v
    }()
    
    private lazy var playListButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        v.setImage(UIImage(systemName: "list.bullet", withConfiguration: config), for: .normal)
        v.tintColor = UIColor(named: "subtitleColor")
        return v
    }()
    
    private lazy var additionalStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [lyricButton, airPlayButton, playListButton])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.distribution = .equalSpacing
        return v
    }()
    
    private var player = AVAudioPlayer()
    private var timer: Timer?
    private var playingIndex = 0
    
    init(album: Album) {
        self.album = album
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetupView
    private func setupView() {
        albumCover.image = UIImage(named: album.image)
        
        setupPlayer(song: album.songs[playingIndex])
        
        // MARK: Set Labels Color
        [songNameLabel, artistLabel, elapsedTimeLabel, remainingTimeLabel].forEach{ (v) in
            v.textColor = .white
        }
        
        // MARK: addSubview Labels
        [albumCover, songNameLabel, artistLabel, progressBar, elapsedTimeLabel, remainingTimeLabel, controlStack, volumeStack, additionalStack].forEach{ (v) in
            addSubview(v)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        //album cover
        NSLayoutConstraint.activate([
            albumCover.widthAnchor.constraint(equalToConstant: 250),
            albumCover.heightAnchor.constraint(equalToConstant: 250),
            albumCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            albumCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            albumCover.topAnchor.constraint(equalTo: topAnchor, constant: 125),
        ])
        
        //song name
        NSLayoutConstraint.activate([
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            songNameLabel.topAnchor.constraint(equalTo: albumCover.bottomAnchor, constant: 100),
        ])
        
        // artist label
        NSLayoutConstraint.activate([
            artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            artistLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8)
        ])
        
        // progress bar
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8),
        ])
        
        // elapsed time
        NSLayoutConstraint.activate([
            elapsedTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            elapsedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 2)
        ])
        
        // remaining time
        NSLayoutConstraint.activate([
            remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 2)
        ])
        
        // control stack
        NSLayoutConstraint.activate([
            controlStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            controlStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            controlStack.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 48),
        ])
        
        // volume bar
        NSLayoutConstraint.activate([
            volumeStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            volumeStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            volumeStack.topAnchor.constraint(equalTo: controlStack.bottomAnchor,constant: 48),
        ])
        
        // additionalStack
        NSLayoutConstraint.activate([
            additionalStack.topAnchor.constraint(equalTo: volumeBar.bottomAnchor, constant: 16),
            additionalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            additionalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64),
        ])
        
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else {
            return
        }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        }

        songNameLabel.text = song.name
        artistLabel.text = song.artist
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            player.volume = Float(0.5)
            volumeBar.value = player.volume
            progressBar.value = 0.0
            progressBar.maximumValue = Float(player.duration)
            
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func play() {
        progressBar.value = 0.0
        progressBar.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    private func setPlayPauseIcon(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.fill" : "play.fill",withConfiguration: config), for: .normal)
    }
    
    @objc private func updateProgress() {
        progressBar.value = Float(player.currentTime)
        
        elapsedTimeLabel.text = getFormattedTime(timeInterval: player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = getFormattedTime(timeInterval: remainingTime)
    }
    
    @objc private func didTapMinVolume(_ sender: UIButton) {
        player.volume = Float(0.0)
        volumeBar.value = player.volume
    }

    @objc private func didTapMaxVolume(_ sender: UIButton) {
        player.volume = Float(1.0)
        volumeBar.value = player.volume
    }
    
    @objc private func volumeScrubbed(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @objc private func progressScrubbed(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @objc private func didTapPrevious(_ sender: UIButton) {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = album.songs.count - 1
        }
        setupPlayer(song: album.songs[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func didTapPlayPause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func didTapNext(_ sender: UIButton) {
        playingIndex += 1
        if playingIndex >= album.songs.count {
            playingIndex = 0
        }
        
        setupPlayer(song: album.songs[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secStr = timeFormatter.string(from: NSNumber(value: secs)) else {
            return "00:00"
        }
        
        return "\(minsString):\(secStr)"
    }
}

extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapNext(nextButton)
    }
}
