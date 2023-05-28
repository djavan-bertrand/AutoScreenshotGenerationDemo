//
//  OrderModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 26/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine

class OrderModelConfigurable: OrderModel {
    private(set) var currentOrder: Order?
    private(set) var orderFuture: Future<Bool, Never>?
    private var orderPromise: ((Result<Bool, Never>) -> Void)?

    private let accountModel: AccountModel

    init(accountModel: AccountModel) {
        self.accountModel = accountModel
    }

    func orderSmoothie(_ smoothie: Smoothie) -> Future<Bool, Never> {
        orderSmoothie(smoothie, offered: false)
    }

    func redeemSmoothie(_ smoothie: Smoothie) -> Future<Bool, Never>? {
        guard accountModel.canRedeemSmoothie() else { return nil }
        return orderSmoothie(smoothie, offered: true)
    }

    private func orderSmoothie(_ smoothie: Smoothie, offered: Bool) -> Future<Bool, Never> {
        orderFuture = nil
        orderPromise = nil
        let order = Order(smoothie: smoothie, points: offered ? 0 : 1, isReady: false)
        currentOrder = order
        let orderId = order.uuid
        let future: Future<Bool, Never> = Future { promise in
            self.orderPromise = promise
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if let order = self.currentOrder, order.uuid == orderId {
                    self.currentOrder?.isReady = true
                }
                promise(.success(true))
            }
        }
        orderFuture = future
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.accountModel.appendOrder(order)
            if offered {
                self.accountModel.redeemSmoothie()
            }
        }
        return future
    }
}
