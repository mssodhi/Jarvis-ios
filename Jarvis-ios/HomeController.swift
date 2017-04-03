import UIKit
import Speech
import LBTAComponents

let twitterBlue = UIColor(r: 61, g: 167, b: 244)

class HomeController: UIViewController, SFSpeechRecognizerDelegate {
    
    // Speech Recognizing Variables
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "JARKIS"
        label.font = UIFont.systemFont(ofSize: 34, weight: UIFontWeightThin)
        label.textAlignment = .center;
        
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center;
        
        return label
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = twitterBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Refresh", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(healthCheck), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    let speakButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = twitterBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Speak", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightThin)
        button.setTitleColor(twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(speakTapped), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        speechRecognizer?.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(refreshButton)
        view.addSubview(speakButton)
        
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 35, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: 50)
        infoLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: 30)
        refreshButton.anchor(infoLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 105, heightConstant: 30)
        speakButton.anchor(infoLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 105, heightConstant: 45)
        
        let centerRefreshButton = NSLayoutConstraint(item: refreshButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerSpeakButton = NSLayoutConstraint(item: speakButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        self.speakButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([centerSpeakButton, centerRefreshButton])
        
        super.viewDidLoad()
        
        healthCheck()
    }
    
    
    func speakTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode?.removeTap(onBus: 0)
            speakButton.setTitle("Speak", for: .normal)
        } else {
            startRecording()
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
                
                if command != nil {
                    
                    self.audioEngine.stop()
                    
                    self.recognitionRequest?.endAudio()
                    self.audioEngine.inputNode?.removeTap(onBus: 0)
                    self.speakButton.setTitle("Speak", for: .normal)
                    
                    JarvisServices.sharedInstance.handleInput(command: command!)
                    
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
    
    func healthCheck() {
        JarvisServices.sharedInstance.statusCheck { (success, err) in
            if err != nil {
                self.infoLabel.text = "Make sure Jarvis server is up and running."
                self.speakButton.isHidden = true
                self.refreshButton.isHidden = false
                return
            }
            self.infoLabel.text = "Connected"
            self.speakButton.isHidden = false
            self.refreshButton.isHidden = true
        }
    }
    
}
