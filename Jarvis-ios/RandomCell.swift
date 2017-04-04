import UIKit
import LBTAComponents

class RandomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let cardView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.image = #imageLiteral(resourceName: "Rockefeller")
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "reply.png").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "retweet").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let directMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send_message").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(cardView)
        
        cardView.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 100, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 300)
        
        let cardCenterConstraintsX = NSLayoutConstraint(item: cardView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([cardCenterConstraintsX])
        setupBottomButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBottomButtons() {
        let replyButtonContainerView = UIView()
//        replyButtonContainerView.backgroundColor = .black
        
        let retweetButtonContainerView = UIView()
//        retweetButtonContainerView.backgroundColor = .yellow
        
        let likeButtonContainerView = UIView()
//        likeButtonContainerView.backgroundColor = .green
        
        let directMessageButtonContainerView = UIView()
//        directMessageButtonContainerView.backgroundColor = .blue
        
        let stack = UIStackView(arrangedSubviews: [replyButtonContainerView, retweetButtonContainerView, likeButtonContainerView, directMessageButtonContainerView])
        
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.backgroundColor = .red
        
        addSubview(stack)
        addSubview(replyButton)
        addSubview(retweetButton)
        addSubview(likeButton)
        addSubview(directMessageButton)
        
        stack.anchor(cardView.bottomAnchor, left: cardView.leftAnchor, bottom: nil, right: cardView.rightAnchor, topConstant: -40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: cardView.frame.width, heightConstant: 40)
        
        replyButton.anchor(replyButtonContainerView.topAnchor, left: replyButtonContainerView.leftAnchor, bottom: replyButtonContainerView.bottomAnchor, right: replyButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        retweetButton.anchor(replyButtonContainerView.topAnchor, left: retweetButtonContainerView.leftAnchor, bottom: retweetButtonContainerView.bottomAnchor, right: retweetButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        likeButton.anchor(likeButtonContainerView.topAnchor, left: likeButtonContainerView.leftAnchor, bottom: likeButtonContainerView.bottomAnchor, right: likeButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        directMessageButton.anchor(directMessageButtonContainerView.topAnchor, left: directMessageButtonContainerView.leftAnchor, bottom: directMessageButtonContainerView.bottomAnchor, right: directMessageButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
