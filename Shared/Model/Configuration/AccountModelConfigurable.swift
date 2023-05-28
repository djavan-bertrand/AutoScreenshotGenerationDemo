//
//  AccountModelConfigurable.swift
//  GenerateScreenshots
//
//  Created by Djavan Bertrand on 30/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine
import AuthenticationServices

class AccountModelConfigurable: AccountModel {
    private(set) var account = CurrentValueSubject<Account?, Never>(nil)

    init() {
        if ConfigurationManager.instance.accountConfigs.contains(.userLogged) {
            createAccount()
            if ConfigurationManager.instance.accountConfigs.contains(.userCanRedeem) {
                if var newAccount = account.value {
                    newAccount.totalPoints = 10
                    newAccount.newPoints = 10
                    account.send(newAccount)
                }
            }
        }
    }

    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        createAccount()
    }

    func appendOrder(_ order: Order) {
        guard var newAccount = account.value else { return }
        newAccount.appendOrder(order)
        account.send(newAccount)
    }

    func canRedeemSmoothie() -> Bool {
        return account.value?.canRedeemFreeSmoothie ?? false
    }

    func redeemSmoothie() {
        guard var newAccount = account.value else { return }
        newAccount.redeemSmoothie()
        account.send(newAccount)
    }

    func clearUnstampedPoints() {
        guard var newAccount = account.value else { return }
        newAccount.clearNewPoints()
        account.send(newAccount)
    }

    private func createAccount() {
        guard account.value == nil else { return }
        let account = Account()
        self.account.send(account)
    }
}
