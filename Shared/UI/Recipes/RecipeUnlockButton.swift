/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A button that unlocks all recipes.
*/

import SwiftUI
import StoreKit

struct RecipeUnlockButton: View {
    var product: DisplayProduct
    var purchaseAction: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("smoothie/recipes-background").resizable()
                .aspectRatio(contentMode: .fill)
                #if os(iOS)
                .frame(height: 225)
                #else
                .frame(height: 150)
                #endif
                .accessibility(hidden: true)
            
            bottomBar
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 0.5)
        }
        .accessibilityElement(children: .contain)
    }
    
    var bottomBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(product.title))
                    .font(.headline)
                    .bold()
                Text(LocalizedStringKey(product.description))
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
            
            if case let .available(displayPrice) = product.availability {
                Button(action: purchaseAction) {
                    Text(displayPrice)
                }
                .buttonStyle(.purchase)
                .accessibility(label: Text("Buy recipe for \(displayPrice)",
                                           comment: "Accessibility label for button to buy recipe for a certain price."))
                .accessibility(identifier: "purchaseButton")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Previews
struct RecipeUnlockButton_Previews: PreviewProvider {
    static let availableProduct = DisplayProduct(
        title: "Unlock All Recipes",
        description: "Make smoothies at home!",
        availability: .available(displayPrice: "$4.99")
    )
    
    static let unavailableProduct = DisplayProduct(
        title: "Unlock All Recipes",
        description: "Loading…",
        availability: .unavailable
    )
    
    static var previews: some View {
        Group {
            RecipeUnlockButton(product: availableProduct, purchaseAction: {})
            RecipeUnlockButton(product: unavailableProduct, purchaseAction: {})
        }
        .frame(width: 300)
        .previewLayout(.sizeThatFits)
    }
}
