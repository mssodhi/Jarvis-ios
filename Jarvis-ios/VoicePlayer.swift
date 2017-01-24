import Foundation
import AVFoundation

class VoicePlayer {
    
    let synthesizer = AVSpeechSynthesizer()

    func textToSpeech(inputText: String) {
        let utterance = AVSpeechUtterance(string: inputText)
        synthesizer.speak(utterance)
    }
    
}
