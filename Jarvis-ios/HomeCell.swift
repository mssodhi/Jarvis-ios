import UIKit
import Speech
import LBTAComponents

let twitterBlue = UIColor(r: 61, g: 167, b: 244)

class HomeCell: UICollectionViewCell, SFSpeechRecognizerDelegate {
    
    public var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    public var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    public var recognitionTask: SFSpeechRecognitionTask?
    public let audioEngine = AVAudioEngine()
    
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
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = twitterBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Refresh", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(healthCheck), for: .touchUpInside)
        
        return button
    }()
    
    lazy var speakButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = twitterBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Speak", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightThin)
        button.setTitleColor(twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(speakTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        speechRecognizer?.delegate = self
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(refreshButton)
        addSubview(speakButton)
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 35, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width, heightConstant: 50)
        infoLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width, heightConstant: 30)
        refreshButton.anchor(infoLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 105, heightConstant: 30)
        speakButton.anchor(infoLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 105, heightConstant: 45)
        
        let refreshButtonConstraints = NSLayoutConstraint(item: refreshButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let speakButtonConstraints = NSLayoutConstraint(item: speakButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        self.speakButton.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([refreshButtonConstraints, speakButtonConstraints])
                
        healthCheck()
    }

    func speakTapped() {
        print("Speak tapped")
        if audioEngine.isRunning {
            UIView.animate(withDuration: 0.4, animations: {
                self.speakButton.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
                self.speakButton.backgroundColor = .white
                self.speakButton.setTitleColor(twitterBlue, for: .normal)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.6, animations: {
                    self.speakButton.transform = CGAffineTransform.identity
                })
            })
            
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode?.removeTap(onBus: 0)
            speakButton.setTitle("Speak", for: .normal)
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.speakButton.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
                self.speakButton.backgroundColor = twitterBlue
                self.speakButton.setTitleColor(.white, for: .normal)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.6, animations: {
                    self.speakButton.transform = CGAffineTransform.identity
                })
            })
            
            startRecording()
            speakButton.setTitle("Stop", for: .normal)
        }
    }
    
    func healthCheck() {
        print("health check")
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






