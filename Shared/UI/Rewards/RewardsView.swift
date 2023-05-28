/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays progress towards the next free smoothie, as well as offers a way for users to create an account.
*/

import SwiftUI
import AuthenticationServices

struct RewardsView: View {
    @ObservedObject private var viewModel = RewardsViewModel()
    
    var body: some View {
        ZStack {
            RewardsCard(
                totalStamps: viewModel.account?.totalPoints ?? 0,
                animatedStamps: viewModel.account?.newPoints ?? 0,
                hasAccount: viewModel.account != nil
            )
            .onDisappear {
                viewModel.clearUnstampedPoints()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()
                if viewModel.account == nil {
                    SignInWithAppleButton(.signUp, onRequest: { _ in }, onCompletion: viewModel.authorizeUser)
                        .frame(minWidth: 100, maxWidth: 400)
                        .padding(.horizontal, 20)
                        #if os(iOS)
                        .frame(height: 45)
                        #endif
                        .padding(.horizontal, 20)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .background(.bar)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(BubbleBackground().ignoresSafeArea())
    }
}

struct SmoothieRewards_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            RewardsView()
                .preferredColorScheme(.light)
            RewardsView()
                .preferredColorScheme(.dark)
            RewardsView()
        }
    }
}
