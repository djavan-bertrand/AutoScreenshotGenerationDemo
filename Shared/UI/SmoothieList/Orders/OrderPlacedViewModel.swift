//
//  OrderPlacedViewModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 26/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AuthenticationServices

class OrderPlacedViewModel: ObservableObject {
    @Published private(set) var hasAccount: Bool
    @Published private(set) var order: Order?

    private let accountModel = model.accountModel
    private let orderModel = model.orderModel

    private var storage = Set<AnyCancellable>()

    init() {
        order = orderModel.currentOrder
        hasAccount = accountModel.account.value != nil

        model.orderModel.orderFuture?.sink { [weak self] _ in
            self?.order = model.orderModel.currentOrder
        }.store(in: &storage)

        accountModel.account.sink { [unowned self] in
            hasAccount = $0 != nil
        }.store(in: &storage)
    }

    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.accountModel.authorizeUser(result)
        }
    }
}
