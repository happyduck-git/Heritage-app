//
//  EditViewController.swift
//  Heritage
//
//  Created by HappyDuck on 2022/02/16.
//

import UIKit
import DropDown
import RealmSwift

class EditViewController: UIViewController {
    
    let cellColors = Colors()
    
    let realm = try! Realm()
    var newRealmData: Results<NewRealmData>?

    let DidDismissPostVC: Notification.Name = Notification.Name("DidDismissPostVC")
    
    var indexPathSelected = Int() //ViewController tableview의 선택한 cell의 indexPath.row
    var sectorPassed = " "
    var titlePassed = " "
    var commentPassed = " "
    
    private let sectorLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true

        return label
    }()
    
    let sectorButton: UIButton = {
        let button = UIButton()
        let cellColors = Colors()
        button.setTitleColor(.darkGray, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = cellColors.mainPink.cgColor
       
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        let cellColors = Colors()
        textField.placeholder = "입력해주세요"
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.backgroundColor = cellColors.mainPink.cgColor
        textField.textAlignment = .center
        textField.widthAnchor.constraint(equalToConstant: 140).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "한줄평"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        let cellColors = Colors()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.cornerRadius = 8
        textView.layer.backgroundColor = cellColors.mainPink.cgColor
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 130).isActive = true
//        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //StackViews
    
    private let sectorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private lazy var editBtn: UIButton = {
        let button = UIButton()
        let cellColor = Colors()
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = cellColor.mainGray
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editBtnPressed), for: .touchUpInside)
        
        return button
    }()
    
    let menu: DropDown = {
        let menus = DropdownMenu()
        let menu = DropDown()
        menu.dataSource = menus.menus
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectorButton.setTitle(sectorPassed, for: .normal)
        titleTextField.text = titlePassed
        commentTextView.text = commentPassed
        //Add views
        view.addSubview(sectorStackView)
        view.addSubview(titleStackView)
        view.addSubview(commentStackView)
        view.addSubview(editBtn)
        stackViewLayout()
        navigationItem.largeTitleDisplayMode = .never
        
        menuButtonGesture() 
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func stackViewLayout() {
   
        //sectorStackView
        sectorStackView.addArrangedSubview(sectorLabel)
        sectorStackView.addArrangedSubview(sectorButton)
        
        sectorStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        sectorStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        //titleStackView
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleTextField)
        
        titleStackView.topAnchor.constraint(equalTo: sectorStackView.bottomAnchor, constant: 20).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        //commentStackView
        commentStackView.addArrangedSubview(commentLabel)
        commentStackView.addArrangedSubview(commentTextView)

        commentStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20).isActive = true
        commentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        //editBtn
        editBtn.topAnchor.constraint(equalTo: commentStackView.bottomAnchor, constant: 20).isActive = true
        editBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc func editBtnPressed() {
        //앞 화면으로 돌아가기
        self.performSegue(withIdentifier: "unwindToViewController", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "unwindToViewController"{
            let mainVC = segue.destination as! MainViewController

            //Realm 사용 시
            let sectorLabel = sectorButton.titleLabel?.text ?? "에러"
            let titleLabel = titleTextField.text ?? "에러"
            let commentText = commentTextView.text ?? "에러"

            if let realData = mainVC.newRealmData?[indexPathSelected] {
                do {
                    try realm.write {
                        realData.sector = sectorLabel
                        realData.title = titleLabel
                        realData.comment = commentText
                    }
                } catch {
                    print("Error saving changes, \(error)")
                }
                mainVC.tableView.reloadData()
            }

            NotificationCenter.default.post(name: DidDismissPostVC, object: nil, userInfo: nil)

            }
    }
    
    @objc func didTapInItem() {
        menu.show()
    }
    
    func menuButtonGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapInItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        sectorButton.addGestureRecognizer(gesture)
        menu.anchorView = sectorButton
        menu.backgroundColor = .white
        menu.cornerRadius = 8
        menu.selectionAction = { index, title in
            print("\(title)")
            self.sectorButton.setTitle(title, for: .normal)
        }
    }
}
