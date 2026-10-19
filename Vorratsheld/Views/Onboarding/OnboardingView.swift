//
//  OnboardingView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct OnboardingView: View {
    let onFinished: () -> Void

    @State private var page = 0

    private let pages = [
        OnboardingPage(title: S.onboarding1Title, text: S.onboarding1Text, accent: Color(hex: 0x3F6B3F)),
        OnboardingPage(title: S.onboarding2Title, text: S.onboarding2Text, accent: Color(hex: 0x3A6470)),
        OnboardingPage(title: S.onboarding3Title, text: S.onboarding3Text, accent: Color(hex: 0xC07A45)),
        OnboardingPage(title: S.onboarding4Title, text: S.onboarding4Text, accent: Color(hex: 0xB8432F))
    ]

    private var isLastPage: Bool { page == pages.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if !isLastPage {
                    Button(S.onboardingSkip, action: onFinished)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                }
            }
            .frame(height: 48)

            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    pageView(index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == page ? pages[page].accent : AppColor.outlineVariant)
                        .frame(width: index == page ? 28 : 8, height: 8)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: page)
            .padding(.vertical, 24)

            PrimaryButton(text: isLastPage ? S.onboardingStart : S.onboardingNext, color: pages[page].accent) {
                if isLastPage {
                    onFinished()
                } else {
                    withAnimation { page += 1 }
                }
            }
            .animation(.easeInOut(duration: 0.4), value: page)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(AppColor.background)
    }

    private func pageView(_ index: Int) -> some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                AccentBlob(color: pages[index].accent)
                switch index {
                case 0: ScanIllustration()
                case 1: OverviewIllustration()
                case 2: ReminderIllustration()
                default: ShoppingIllustration()
                }
            }
            .frame(width: 280, height: 280)

            Text(pages[index].title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            Text(pages[index].text)
                .font(.body)
                .foregroundStyle(AppColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .padding(.top, 12)
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {}
}
