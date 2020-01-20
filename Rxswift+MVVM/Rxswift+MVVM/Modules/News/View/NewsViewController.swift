//
//  NewsViewController.swift
//  Rxswift+MVVM
//
//  Created by xuanze on 2020/1/17.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRefresh: UIButton!
    
    private let viewModel = NewsViewModel()
    private let offset = BehaviorRelay<String>(value: "0")
    private var dataSource: RxTableViewSectionedReloadDataSource<NewsListModel>!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        let ouput = viewModel.transform(input: offset, dependecies: NetworkManager.shareInstance)
        
        tableView.register(OneImageNewsTableViewCell.self, forCellReuseIdentifier: "OneImageNewsTableViewCell")
        tableView.register(ThreeImagesTableViewCell.self, forCellReuseIdentifier: "ThreeImagesTableViewCell")
        self.dataSource = RxTableViewSectionedReloadDataSource<NewsListModel>  (configureCell: { (dataSource, tabView, indexPath, item) -> UITableViewCell in
            if item.imgnewextra?.isEmpty ?? true {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "OneImageNewsTableViewCell", for: indexPath) as? OneImageNewsTableViewCell
                cell?.setup(item)
                return cell!
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ThreeImagesTableViewCell", for: indexPath) as? ThreeImagesTableViewCell
                cell?.setup(item)
                return cell!
            }
        })
        ouput.drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
            
        btnRefresh.rx.tap.bind { [weak self] in
            let offsexValue = Int(self?.offset.value ?? "")
            self?.offset.accept("\((offsexValue ?? 0) + 10)")
        }
        .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
    }
}


extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsSection = dataSource.sectionModels[indexPath.section]
        let news = newsSection.items[indexPath.row]
        if news.imgnewextra?.isEmpty ?? true {
            return 100.0
        }
        return 180.0
    }
}
