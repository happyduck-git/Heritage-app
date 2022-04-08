//
//  MainViewController.swift
//  Heritage
//
//  Created by HappyDuck on 2022/02/14.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
            
    let realm = try! Realm()
    var newRealmData: Results<NewRealmData>?
    
    let writeVC = WriteViewController()
    let editVC = EditViewController()
    let collectionTableViewCell = CollectionTableViewCell()
    
    let cellColors = Colors()
    let sections = ["Best 3", "전체글"]
    let sectionImages = [UIImage(systemName: "crown"), UIImage(systemName: "list.star")]
    
    var indexPathNum = Int() //indexPath.row 저장을 위한 Int 변수 생성

    //두 종류의 셀 형태를 같는 테이블 뷰 생성 (0번째 행은 CollectiontableView, 1번째 이하는 CardCell Nib 사용)
    let tableView:UITableView = {
        let table = UITableView()

        table.register(
            CollectionTableViewCell.self,
            forCellReuseIdentifier: CollectionTableViewCell.identifier
        )
        table.register(
            UINib(nibName: "CardCell", bundle: nil),
            forCellReuseIdentifier: "ReusableCell"
        )
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = cellColors.viewBackgroundColor
        //네비게이션바 타이틀 크기 설정
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //네비게이션바 Large타이틀 글씨체 변경
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSerifKR-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30)]

        //네비게이션바 버튼 설정
        configureItems()
        navigationController?.navigationBar.tintColor = .label //.label은 dark or light mode에 따라 글자 색상이 바뀌게 하는 것
        
        //테이블뷰 등록
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        //Refreching Data
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                          action: #selector(didPullToRefresh),
                                          for: .valueChanged)
        loadRealmData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostNotification(_:)), name: writeVC.DidDismissPostVC, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    @IBAction func prepareForUnWind(segue: UIStoryboardSegue){
        
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
       
        let image = UIImageView(image: sectionImages[section])
        image.tintColor = cellColors.mainPink
        view.addSubview(image)
        
        let label = UILabel()
        label.text = sections[section]
        label.font = UIFont(name: "NotoSerifKR-Bold", size: 23)
        view.addSubview(label)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return newRealmData?.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Collection view 들어가는 곳
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
                fatalError()
            }
            return cell
            
        //Table view 그대로 남아 있는 곳
        } else if indexPath.row >= 0 && indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CardCell
            let model = newRealmData?[indexPath.row]
            cell.commonInit(
                rank: String(indexPath.row + 1),
                sector: model?.sector ?? "",
                title: model?.title ?? "",
                comment: model?.comment ?? "아직 업로드 된 데이터가 없습니다.",
                likeNumber: String(model?.likeCount ?? 0),
                done: model?.done ?? false
            )
            
            cell.isLiked = newRealmData?[indexPath.row].done ?? false
            cell.callback = { [weak self] theCell, isLiked in
                guard let self = self,
                      let pth = self.tableView.indexPath(for: theCell)
                else { return }
                do {
                    try self.realm.write {
                        self.newRealmData?[pth.row].done = isLiked
                        if isLiked == true {
                            self.newRealmData?[pth.row].likeCount += 1
                        } else {
                            self.newRealmData?[pth.row].likeCount -= 1
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Error saving changes, \(error)")
                }
            }
            cell.textLabel?.numberOfLines = 0
            cell.commentAdded.numberOfLines = 0
            
            //셀 배경색
            cell.cardBubble.backgroundColor = cellColors.mainPink
            return cell
   
        } else {
            return UITableViewCell()
        }
        
    }
    
    func loadRealmData() {
        newRealmData = realm.objects(NewRealmData.self)
        collectionTableViewCell.loadRealmData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return view.frame.size.width/1.6
        }
        return 160
    }

    
    //Swipe 기능 추가 (수정&삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //삭제
        let deleteAction = UIContextualAction(style: .normal , title: "삭제", handler: {action, view, completionHandler in
            
            self.checkPassword(indexPath: indexPath.row) {
                //Realm 사용으로 변경 후
                if let realmData = self.newRealmData?[indexPath.row] {
                    do {
                        try self.realm.write {
                            self.realm.delete(realmData)
                        }
                    } catch {
                        print("Error deleting data, \(error)")
                    }
                }
                
                //위의 셀 삭제되면 랭킹 라벨에 번호 새로 매겨지도록 테이블뷰를 새로 업로드
                self.tableView.reloadData()
            }

        })
        
        //수정
        let editAction = UIContextualAction(style: .normal, title: "수정", handler: {action, view, completionHandler in
            
            self.indexPathNum = indexPath.row //indexPath.row 값 저장
            self.checkPassword(indexPath: self.indexPathNum){
                DispatchQueue.main.async() {
                    self.performSegue(withIdentifier: "goToEdit", sender: self)
                }
            }
        })
        
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .darkGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func configureItems() {
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "plus.bubble") , style: .done, target: self, action: #selector(btnTapped))
    }
    
    @objc func btnTapped() {
        self.performSegue(withIdentifier: "goToWrite", sender: self)
    }
    
    @objc func presentModalController() {
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        // Keep animated value as false
        // Custom Modal presentation animation will be handled in VC itself
        self.present(vc, animated: false)
    }
    
    //MARK: - Prepare for Segue
    //수정화면 전환 전 값 저장
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit"{
            let destinationVC = segue.destination as! EditViewController
            
            //API 사용 시
            destinationVC.sectorPassed = newRealmData?[indexPathNum].sector ?? "섹터"
            destinationVC.titlePassed = newRealmData?[indexPathNum].title ?? "타이틀"
            destinationVC.commentPassed = newRealmData?[indexPathNum].comment ?? "코멘트"
            destinationVC.indexPathSelected = indexPathNum
        }
    }

    
    @objc func didDismissPostNotification(_ noti: Notification) {
        loadRealmData()
    }
    
    @objc func didPullToRefresh() {
        loadRealmData()
        print("loaded")
      
    }

    func checkPassword(indexPath: Int, completion: @escaping ()->()) {
        var textField = UITextField()
        let alert = UIAlertController(title: "비밀번호를 입력하세요", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { action in
            //Confirm 버튼을 눌렀을 때 발생할 일
            if let password = textField.text, let realmData = self.newRealmData {
                if password == realmData[indexPath].pw {
                    print("Correct Password")
                    completion()
                } else {
                    self.incorrectPasswordAlert(indexPath: indexPath)
                }
            } else {print("No text input") }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "비밀번호"
            alertTextField.isSecureTextEntry = true
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        }
    }
    
    func incorrectPasswordAlert(indexPath: Int) {
        let alert = UIAlertController(title: "비밀번호를 확인해주세요", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { action in
            //Confirm 버튼을 눌렀을 때 발생할 일
            self.checkPassword(indexPath: indexPath){
                DispatchQueue.main.async() {
                    self.performSegue(withIdentifier: "goToEdit", sender: self)
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        }
    }
    //Alert 창 밖에 눌렀을 때 alert dismiss 되도록 하기
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
}

