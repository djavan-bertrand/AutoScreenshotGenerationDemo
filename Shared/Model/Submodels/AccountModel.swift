//
//  AccountModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 26/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

struct Account {
    static let freeSmoothiePoint = 10
    var totalPoints = 0
    var newPoints = 0

    var canRedeemFreeSmoothie: Bool {
        totalPoints >= Self.freeSmoothiePoint
    }

    mutating func appendOrder(_ order: Order) {
        totalPoints += order.points
        newPoints += order.points
    }

    mutating func redeemSmoothie() {
        totalPoints -= Self.freeSmoothiePoint
    }

    mutating func clearNewPoints() {
        newPoints = 0
    }
}

protocol AccountModel {
    var account: CurrentValueSubject<Account?, Never> { get }

    func authorizeUser(_ result: Result<ASAuthorization, Error>)

    func appendOrder(_ order: Order)
    func canRedeemSmoothie() -> Bool
    func redeemSmoothie()
    func clearUnstampedPoints()
}

class AccountModelDefault: AccountModel {
    private(set) var account = CurrentValueSubject<Account?, Never>(nil)

    private let userDefaults = UserDefaults.standard
    private let userCredsKey = "userCreds"
    private let totalPointsKey = "totalPoints"

    init() {
        guard let user = userDefaults.string(forKey: userCredsKey) else { return }
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: user) { state, error in
            if state == .authorized || state == .transferred {
                DispatchQueue.main.async {
                    self.createAccount()
                }
            }
        }
    }

    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let authorization) = result, let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            if case .failure(let error) = result {
                print("Authentication error: \(error.localizedDescription)")
            }
            return
        }
        userDefaults.set(credential.user, forKey: userCredsKey)
        createAccount()
    }

    func appendOrder(_ order: Order) {
        guard var newAccount = account.value else { return }
        newAccount.appendOrder(order)
        userDefaults.set(newAccount.totalPoints, forKey: totalPointsKey)
        account.send(newAccount)
    }

    func canRedeemSmoothie() -> Bool {
        return account.value?.canRedeemFreeSmoothie ?? false
    }

    func redeemSmoothie() {
        guard var newAccount = account.value else { return }
        newAccount.redeemSmoothie()
        userDefaults.set(newAccount.totalPoints, forKey: totalPointsKey)
        account.send(newAccount)
    }

    func clearUnstampedPoints() {
        guard var newAccount = account.value else { return }
        newAccount.clearNewPoints()
        account.send(newAccount)
    }

    private func createAccount() {
        guard account.value == nil else { return }
        var account = Account()
        account.totalPoints = userDefaults.integer(forKey: totalPointsKey)
        self.account.send(account)
    }
}
