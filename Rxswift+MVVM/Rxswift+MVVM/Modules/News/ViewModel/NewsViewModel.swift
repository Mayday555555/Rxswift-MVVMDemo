//
//  NewsViewModel.swift
//  Rxswift+MVVM
//
//  Created by xuanze on 2020/1/17.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
class NewsViewModel: NSObject {
    
    private var offset:BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func transform(input: BehaviorRelay<String>, dependecies: NetworkManager) -> Driver<[NewsListModel]> {
        self.offset = input
        print(self.offset.value)
        return offset.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()//直到元素的值发生变化，才发出新的元素，offset发生变化即触发网络请求
            .flatMap { (str) -> Observable<[NewsListModel]> in
                let dict = ["from": "T1348649079062",
                            "devId": "H71eTNJGhoHeNbKnjt0%2FX2k6hFppOjLRQVQYN2Jjzkk3BZuTjJ4PDLtGGUMSK%2B55",
                            "version": "54.6",
                            "spever": "false",
                            "net": "wifi",
                            "ts": "\(Date().timeStamp)",
                            "sign": "BWGagUrUhlZUMPTqLxc2PSPJUoVaDp7JSdYzqUAy9WZ48ErR02zJ6%2FKXOnxX046I",
                            "encryption": "1",
                            "canal": "appstore",
                            "offset": str,
                            "size": "10",
                            "fn": "3"]
                return Observable<[NewsListModel]>.create { (obsever) -> Disposable in
                    dependecies.requestNetworkData(.get, hostType: .Base, urlString: .GetNewsList, dict, nil, successHandler: { (code, json, msg) in
                        let news = self.getObserval(json: json)
                        obsever.onNext(news)
                    }) {error in
                        if error != nil {
                            obsever.onError(error!)
                        } else {
                            obsever.onError(BaseError(desc: "请求数据失败"))
                        }
                        
                    }
                    return Disposables.create()
                }
        }.asDriver(onErrorJustReturn: [])
        
    }
    
    private func getObserval(json: JSON) -> [NewsListModel] {
        guard let json = json["T1348649079062"].array else { return [] }
        var news: [NewsModel] = []
        json.forEach {
            guard !$0.isEmpty else { return }
            var imgnewextras: [Imgnewextra] = []
            if let imgnewextraJsonArray = $0["imgnewextra"].array {
                imgnewextraJsonArray.forEach {
                    let subItem = Imgnewextra(imgsrc: $0["imgsrc"].string ?? "")
                    imgnewextras.append(subItem)
                }
            }
            let new = NewsModel(title: $0["title"].string ?? "", imgsrc: $0["imgsrc"].string ?? "", replyCount: $0["replyCount"].string ?? "", source: $0["source"].string ?? "", imgnewextra: imgnewextras)
            
            news.append(new)
        }
        return [NewsListModel(header: "1", items: news)]
    }
}
