//
//  NewsListModel.swift
//  Rxswift+MVVM
//
//  Created by xuanze on 2020/1/19.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxDataSources
import SwiftyJSON

struct NewsModel {
    var title: String
    var imgsrc: String
    var replyCount: String
    var source: String
    var imgnewextra: [Imgnewextra]?
}

struct Imgnewextra {
    var imgsrc: String
}

struct NewsListModel {
    var header: String?
    var items: [NewsModel]
}

extension NewsListModel: SectionModelType {
     
    
    typealias Item = NewsModel
    
    init(original: NewsListModel, items: [NewsModel]) {
        self = original
        self.items = items
    }
}
