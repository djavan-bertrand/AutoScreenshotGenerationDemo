//
//  StoreModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 29/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import StoreKit
import Combine

struct DisplayProduct {
    let title: String
    let description: String
    let availability: Availability
    fileprivate let product: Product?

    init(title: String, description: String, availability: Availability) {
        self.title = title
        self.description = description
        self.availability = availability
        self.product = nil
    }

    enum Availability {
        case available(displayPrice: String)
        case unavailable
    }
}

class StoreModel {
    static let unlockAllRecipesIdentifier = "com.example.apple-samplecode.fruta.unlock-recipes"

    let allRecipesUnlocked = CurrentValueSubject<Bool, Never>(false)
    let unlockAllRecipesProduct = CurrentValueSubject<DisplayProduct?, Never>(nil)

    private let allProductIdentifiers = Set([StoreModel.unlockAllRecipesIdentifier])
    private var fetchedProducts: [Product] = []
    private var updatesHandler: Task<Void, Error>? = nil

    init() {
        // Start listening for transaction info updates, like if the user
        // refunds the purchase or if a parent approves a child's request to
        // buy.
        updatesHandler = Task {
            await listenForStoreUpdates()
        }
        fetchProducts()
    }

    func product(for identifier: String) -> Product? {
        return fetchedProducts.first(where: { $0.id == identifier })
    }

    func purchase(product: DisplayProduct) {
        guard let product = product.product else { return }
        Task { @MainActor in
            do {
                let result = try await product.purchase()
                guard case .success(.verified(let transaction)) = result,
                      transaction.productID == StoreModel.unlockAllRecipesIdentifier else {
                    return
                }
                self.allRecipesUnlocked.send(true)
            } catch {
                print("Failed to purchase \(product.id): \(error)")
            }
        }
    }

    private func fetchProducts() {
        Task { @MainActor in
            self.fetchedProducts = try await Product.products(for: allProductIdentifiers)
            self.unlockAllRecipesProduct.send(DisplayProduct(
                from: fetchedProducts.first { $0.id == StoreModel.unlockAllRecipesIdentifier }))
            // Check if the user owns all recipes at app launch.
            await self.updateAllRecipesOwned()
        }
    }

    @MainActor
    private func updateAllRecipesOwned() async {
        guard let product = self.unlockAllRecipesProduct.value?.product else {
            self.allRecipesUnlocked.send(false)
            return
        }
        guard let entitlement = await product.currentEntitlement,
              case .verified(_) = entitlement else {
                  self.allRecipesUnlocked.send(false)
                  return
        }
        self.allRecipesUnlocked.send(true)
    }

    /// - Important: This method never returns, it will only suspend.
    @MainActor
    private func listenForStoreUpdates() async {
        for await update in Transaction.updates {
            guard case .verified(let transaction) = update else {
                print("Unverified transaction update: \(update)")
                continue
            }
            guard transaction.productID == StoreModel.unlockAllRecipesIdentifier else {
                continue
            }
            // If this transaction was revoked, make sure the user no longer
            // has access to it.
            if transaction.revocationReason != nil {
                print("Revoking access to \(transaction.productID)")
                self.allRecipesUnlocked.send(false)
            } else {
                self.allRecipesUnlocked.send(true)
                await transaction.finish()
            }
        }
    }
}

private extension DisplayProduct {
    init?(from product: Product?) {
        guard let product = product else { return nil }
        title = product.displayName
        description = product.description
        availability = .available(displayPrice: product.displayPrice)
        self.product = product
    }
}
