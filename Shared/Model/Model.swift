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

    init(forConfiguration: Bool) {
        if !forConfiguration {
            favoriteSmoothiesModel = FavoriteSmoothiesModelDefault()
            accountModel = AccountModelDefault()
            storeModel = StoreModelDefault()
            orderModel = OrderModelDefault(accountModel: accountModel)
        } else {
            favoriteSmoothiesModel = FavoriteSmoothiesModelConfigurable()
            accountModel = AccountModelConfigurable()
            storeModel = StoreModelConfigurable()
            orderModel = OrderModelConfigurable(accountModel: accountModel)
        }

        // non configurable models
        searchModel = SearchModel()
    }
}
