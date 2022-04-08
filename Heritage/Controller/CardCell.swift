//
//  CardCell.swift
//  Heritage
//
//  Created by HappyDuck on 2022/02/04.
//

import UIKit
import RealmSwift

class CardCell: UITableViewCell {
    
    let mainVC = MainViewController()
    var indexPathNum = 0
    var likeNumber = 0
    
    var callback: ((UITableViewCell, Bool) -> ())?

    var likeIMG: UIImage!
    var unlikeIMG: UIImage!
    var isLiked: Bool = false {
        didSet {
            likeImage.image = isLiked ? likeIMG : unlikeIMG
            likeImage.tintColor = isLiked ? .systemRed : .darkGray
        }
    }
        
    @IBOutlet var sectorAdded: UILabel!
    @IBOutlet var titleAdded: UILabel!
    @IBOutlet var commentAdded: UILabel!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var cardBubble: UIStackView!
    @IBOutlet var likeImage: UIImageView! {
        didSet {
            likeImage.isUserInteractionEnabled = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let img1 = UIImage(systemName: "heart.fill"),
              let img2 = UIImage(systemName: "heart")
        else {
            fatalError("Could not load the heart images")
        }
        likeIMG = img1
        unlikeIMG = img2
        
        cardBubble.layer.cornerRadius = cardBubble.frame.size.height/5
        cardBubble.layer.borderWidth = 0
        cardBubble.layer.borderColor = UIColor.black.cgColor
        
        titleAdded.font = UIFont(name: "NotoSerifKR-Bold", size: 17)
        
        //Tap Gesture Recognizer 실행하기
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        likeImage.addGestureRecognizer(tapGestureRecognizer)
        
        //Like count 올리기
        likeCount.text = String(likeNumber)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //테이블뷰 행 간 공백 주기
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func commonInit(rank: String, sector: String, title: String, comment: String, likeNumber: String, done: Bool) {
        rankLabel.text = rank
        sectorAdded.text = sector
        titleAdded.text = title
        commentAdded.text = comment
        likeCount.text = String(likeNumber)
        isLiked = done
    }
    
    @objc func didTapImageView(_ sender: UITapGestureRecognizer) {
        
        isLiked.toggle()
        callback?(self, isLiked)

    }

}
