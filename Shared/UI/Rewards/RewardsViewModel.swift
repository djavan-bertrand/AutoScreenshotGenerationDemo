//
//  RewardsViewModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 29/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

class RewardsViewModel: ObservableObject {
    private let accountModel = model.accountModel

    @Published private(set) var account: Account?

    private var storage = Set<AnyCancellable>()

    init() {
        accountModel.account.sink { [unowned self] in
            account = $0
        }.store(in: &storage)
    }

    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.accountModel.authorizeUser(result)
        }
    }

    func clearUnstampedPoints() {
        accountModel.clearUnstampedPoints()
    }
}
