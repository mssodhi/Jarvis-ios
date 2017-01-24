import Foundation

class JarvisMusicController {

    let jarvisServices = JarvisServices()
    let voicePlayer = VoicePlayer()
    
    static let nextSongCommands: [String] = ["next", "next song", "next track", "play next", "skip"]
    static let pauseCommands: [String] = ["pause", "stop"]
    static let playTopCommands: [String] = ["play top music", "play top", "top music"]
    static let muteCommands: [String] = ["mute"]
    static let unMuteCommands: [String] = ["unmute"]
    static let playMusicCommands: [String] = ["play", "play music"]
    static let previousCommands: [String] = ["previous", "last", "last song", "back"]
    
    static let allCommands: [String] = nextSongCommands + pauseCommands + playTopCommands + muteCommands + unMuteCommands + playMusicCommands + previousCommands
    
    func handleInput (command: String) {
        
        NSLog("Input Command: ", command)
        
        if JarvisMusicController.nextSongCommands.contains(command) {
            self.next()
        }
        
        if JarvisMusicController.pauseCommands.contains(command) {
            self.pause()
        }
        
        if JarvisMusicController.playTopCommands.contains(command) {
            self.playTopMusic()
        }
        
        if JarvisMusicController.muteCommands.contains(command) {
            self.mute()
        }
        
        if JarvisMusicController.unMuteCommands.contains(command) {
            self.unMute()
        }
        
        if JarvisMusicController.playMusicCommands.contains(command) {
            self.play()
        }
        
        if JarvisMusicController.previousCommands.contains(command) {
            self.previous()
        }
        
        if !JarvisMusicController.allCommands.contains(command) {
            voicePlayer.textToSpeech(inputText: VoicesEnum.UNKNOWN.rawValue)
        }
    }
    
    func playTopMusic() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.PLAY_TOP.rawValue)
        jarvisServices.api(url: "/playTop100")
    }
    
    func mute() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.MUTE.rawValue)
        jarvisServices.api(url: "/mute")
    }
    
    func unMute() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.UNMUTE.rawValue)
        jarvisServices.api(url: "/unMute")
    }
    
    func play() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.PLAY.rawValue)
        jarvisServices.api(url: "/play")
    }
    
    func pause() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.PAUSE.rawValue)
        jarvisServices.api(url: "/pause")
    }
    
    func next() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.NEXT.rawValue)
        jarvisServices.api(url: "/next")
    }
    
    func previous() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.PREVIOUS.rawValue)
        jarvisServices.api(url: "/previous")
    }

}
