/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view presented to the user once they order a smoothie, and when it's ready to be picked up.
*/

import SwiftUI
import AuthenticationServices
import StoreKit

struct OrderPlacedView: View {
    @ObservedObject private var viewModel = OrderPlacedViewModel()
    
    #if APPCLIP
    @State private var presentingAppStoreOverlay = false
    #endif
    
    var orderReady: Bool {
        guard let order = viewModel.order else { return false }
        return order.isReady
    }
    
    var presentingBottomBanner: Bool {
        #if APPCLIP
        if presentingAppStoreOverlay { return true }
        #endif
        return !viewModel.hasAccount
    }
    
/// - Tag: ActiveCompilationConditionTag
    var body: some View {

        VStack(spacing: 0) {
            Spacer()
            
            orderStatusCard
            
            Spacer()
            
            if presentingBottomBanner {
                bottomBanner
            }
            
            #if APPCLIP
            Text(verbatim: "App Store Overlay")
                .hidden()
                .appStoreOverlay(isPresented: $presentingAppStoreOverlay) {
                    SKOverlay.AppClipConfiguration(position: .bottom)
                }
            #endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                if let order = viewModel.order {
                    order.smoothie.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color("order-placed-background")
                }
                
                if viewModel.order?.isReady == false {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
            }
            .ignoresSafeArea()
        }
        .animation(.spring(response: 0.25, dampingFraction: 1), value: orderReady)
        .animation(.spring(response: 0.25, dampingFraction: 1), value: viewModel.hasAccount)
    }
    
    var orderStatusCard: some View {
        FlipView(visibleSide: orderReady ? .back : .front) {
            Card(
                title: "Thank you for your order!",
                subtitle: "We will notify you when your order is ready."
            )
                .accessibility(identifier: "preparingOrderCard")
        } back: {
            let smoothieName = viewModel.order?.smoothie.title ?? String(localized: "Smoothie", comment: "Fallback name for smoothie")
            Card(
                title: "Your smoothie is ready!",
                subtitle: "\(smoothieName) is ready to be picked up."
            )
                .accessibility(identifier: "orderReadyCard")
        }
        .animation(.flipCard, value: orderReady)
        .padding()
    }
    
    var bottomBanner: some View {
        VStack {
            if !viewModel.hasAccount {
                Text("Sign up to get rewards!")
                    .font(Font.headline.bold())
                
                SignInWithAppleButton(.signUp, onRequest: { _ in }, onCompletion: viewModel.authorizeUser)
                    .frame(minWidth: 100, maxWidth: 400)
                    .padding(.horizontal, 20)
                    #if os(iOS)
                    .frame(height: 45)
                    #endif
            } else {
                #if APPCLIP
                if presentingAppStoreOverlay {
                    Text("Get the full smoothie experience!")
                        .font(Font.title2.bold())
                        .padding(.top, 15)
                        .padding(.bottom, 150)
                }
                #endif
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.bar)
    }
    
    struct Card: View {
        var title: LocalizedStringKey
        var subtitle: LocalizedStringKey
        
        var body: some View {
            VStack(spacing: 16) {
                Text(title)
                    .font(Font.title.bold())
                    .textCase(.uppercase)
                    .layoutPriority(1)
                Text(subtitle)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 36)
            .frame(width: 300, height: 300)
            .background(in: Circle())
        }
    }
}

struct OrderPlacedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            #if !APPCLIP
            OrderPlacedView()
            #endif
        }
    }
}
