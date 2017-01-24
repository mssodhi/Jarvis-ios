import Foundation

class JarvisBrowserController {

    static let openCommands: [String] = ["browser", "chrome", "google", "google chrome", "open", "open chrome"]
    static let fbCommands: [String] = ["open facebook", "facebook"]
    static let netflixCommands: [String] = ["open netflix", "netflix"]
    static let yahooCommands: [String] = ["open yahoo", "yahoo"]
    static let allCommands: [String] = openCommands + fbCommands + netflixCommands + yahooCommands
    
    let jarvisServices = JarvisServices()
    let voicePlayer = VoicePlayer()
    
    func handleInput(command: String) {
        if JarvisBrowserController.openCommands.contains(command) {
            self.open()
        }
        
        if JarvisBrowserController.fbCommands.contains(command) {
            self.openFb()
        }
        
        if JarvisBrowserController.netflixCommands.contains(command) {
            self.openNetflix()
        }
        
        if JarvisBrowserController.yahooCommands.contains(command) {
            self.openYahoo()
        }
    }
    
    func open() {
        voicePlayer.textToSpeech(inputText: VoicesEnum.OPEN_CHROME.rawValue)
        jarvisServices.api(url: "/openChrome")
    }
    
    func openFb() {
        jarvisServices.api(url: "/openFb")
    }
    
    func openNetflix() {
        jarvisServices.api(url: "/openNetflix")
    }
    
    func openYahoo() {
        jarvisServices.api(url: "/openYahoo")
    }
}
