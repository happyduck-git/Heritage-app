//
//  TopRankCollectionViewCell.swift
//  Heritage
//
//  Created by HappyDuck on 2022/02/14.
//

import UIKit


struct TopRankCollectionViewCellViewModel {
    var userName: String = "user"
    var pw: String = "1234"
    var sector: String = "sector"
    var title: String = "title"
    var comment: String = "comment"
    var likeCount: Int = 0
    var done: Bool = false
}

class TopRankCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopRankCollectionViewCell"
    
    let colorPalette = Colors()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "NotoSerifKR-Regular", size: 15.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "NotoSerifKR-Bold", size: 20.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "NotoSerifKR-Regular", size: 15.0)
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: 220).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "NotoSerifKR-Regular", size: 15.0)
        label.textAlignment = .right
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(sectionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(userNameLabel)
        
        setupLayout()
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func commonInit(sector: String, title: String, comment: String, userName: String) {
        
        sectionLabel.text = sector
        titleLabel.text = title
        commentLabel.text = comment
        userNameLabel.text = "작성자: \(userName)"
        
    }
    
    private func setupLayout(){
        sectionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        sectionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true

        commentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true

        userNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: -10).isActive = true

    }
    
    private func setupBorder(){
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 4
        contentView.layer.borderColor = colorPalette.mainPink.cgColor
    }
    

}
