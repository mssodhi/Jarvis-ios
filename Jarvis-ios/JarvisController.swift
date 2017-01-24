import Foundation

class JarvisController {
 
    let musicController = JarvisMusicController()
    let browserController = JarvisBrowserController()
    
    func handleInput(command: String) {
        if JarvisMusicController.allCommands.contains(command) {
            musicController.handleInput(command: command)
        } else {
            browserController.handleInput(command: command)
        }
    }
}
