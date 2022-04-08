//
//  CollectionTableViewCell.swift
//  Heritage
//
//  Created by HappyDuck on 2022/02/14.
//

import UIKit
import RealmSwift

struct CollectionTableViewCellViewModel {
    let viewModels: [TopRankCollectionViewCellViewModel]
}

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let identifier = "CollectionTableViewCell"
    
    var cardData = [TopRankCollectionViewCellViewModel]()
    let realm = try! Realm()
    var newRealmData: Results<NewRealmData>?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            TopRankCollectionViewCell.self,
            forCellWithReuseIdentifier: TopRankCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .systemBackground
        //가로 스크롤바 숨기기
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        loadRealmData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    override func awakeFromNib() {
        super.awakeFromNib()
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let savedData = newRealmData {
            if savedData.count > 3 {
                return 3
            } else {
                return savedData.count
            }
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopRankCollectionViewCell.identifier,
            for: indexPath
        ) as? TopRankCollectionViewCell else {
            fatalError()
        }
        cell.commonInit(
            sector: newRealmData?[indexPath.row].sector ?? "",
            title: newRealmData?[indexPath.row].title ?? "",
            comment: newRealmData?[indexPath.row].comment ?? "업로드된 데이터가 아직 없습니다!",
            userName: newRealmData?[indexPath.row].userName ?? "")

        return cell
    }
    
    func loadRealmData() {
        newRealmData = realm.objects(NewRealmData.self).sorted(byKeyPath: "likeCount", ascending: false)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = contentView.frame.size.width/1.3
        return CGSize(width: width, height: width/1.45)
    }

}

