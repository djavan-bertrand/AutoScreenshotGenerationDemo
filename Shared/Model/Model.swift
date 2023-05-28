//
//  NewModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 16/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine

class Model {

    let favoriteSmoothiesModel: FavoriteSmoothiesModel
    let searchModel: SearchModel
    let accountModel: AccountModel
    let orderModel: OrderModel
    let storeModel: StoreModel

    init() {
        favoriteSmoothiesModel = FavoriteSmoothiesModel()
        accountModel = AccountModel()
        storeModel = StoreModel()
        orderModel = OrderModel(accountModel: accountModel)
        searchModel = SearchModel()
    }
}
