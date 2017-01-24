import UIKit
import Speech

class FirstViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    // All outlets
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    // Base Url for JARVIS Server
    let BASE_URL = Bundle.main.infoDictionary!["BASE_URL"] as! String
    
    // Custom Services and Classes
    let jarvisController = JarvisController()
    
    // Speech Recognizing Variables
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        speechRecognizer?.delegate = self
        textView.isHidden = true
        
        super.viewDidLoad()
        healthCheck()
    }
    
    @IBAction func speakTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            textView.isHidden = true
            recognitionRequest?.endAudio()
            audioEngine.inputNode?.removeTap(onBus: 0)
            speakButton.setTitle("Speak", for: .normal)
        } else {
            textView.isHidden = false
            startRecording()
            textView.text = "Say something, I'm listening!"
            speakButton.setTitle("Stop", for: .normal)
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            if result != nil {
                let command = result?.bestTranscription.formattedString.lowercased()
                self.textView.text = command
                if command != nil {
                    
                    self.audioEngine.stop()
                    self.textView.isHidden = true
                    self.recognitionRequest?.endAudio()
                    self.audioEngine.inputNode?.removeTap(onBus: 0)
                    self.speakButton.setTitle("Speak", for: .normal)
                    
                    self.jarvisController.handleInput(command: command!)
                    
                }
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        healthCheck()
    }
    
    // if Jarvis isn't running, hide the buttons, and show message
    func healthCheck() {
        refreshButton.isHidden = true
        speakButton.isHidden = true
        let url = URL(string: "http://" + BASE_URL + "/status")
        
        let urlRequest: URLRequest = URLRequest(url: url!)
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            
            if (statusCode == 200) {
                print("Jarvis Up and Running")
                self.infoLabel.isHidden = true
                self.speakButton.isHidden = false
            }else{
                self.infoLabel.text = "Please make sure Jarvis Server is up and running."
                self.infoLabel.isHidden = false
                self.refreshButton.isHidden = false
            }
            
        }
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
