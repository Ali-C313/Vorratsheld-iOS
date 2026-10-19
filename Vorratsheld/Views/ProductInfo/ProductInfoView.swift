//
//  ProductInfoView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ProductInfoView: View {

    let productId: String

    @Environment(AppViewModel.self) private var appViewModel
    @Environment(ProductViewModel.self) private var productViewModel

    @State private var showDeleteAlert = false
    @State private var snackbar: SnackbarMessage?

    var body: some View {
        Group {
            if let product = productViewModel.product(withId: productId) {
                content(product)
            } else {
                VStack(spacing: 12) {
                    Text(S.errorProductNotFound)
                        .font(.headline)
                    Button(S.actionBack) {
                        appViewModel.navigateBack()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(AppColor.surface)
        .snackbar($snackbar, bottomPadding: 90)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func content(_ product: Product) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                InfoHeader(product: product)
                InfoBody(product: product)
                    .offset(y: -28)
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .top) {
            headerButtons(product)
        }
        .safeAreaInset(edge: .bottom) {
            ActionBar(
                onDeleteClick: {
                    showDeleteAlert = true
                },
                onAddToListClick: {
                    productViewModel.addToShoppingList(product) {
                        snackbar = SnackbarMessage(text: S.infoAddedToList(product.name))
                    }
                },
                onEditClick: {
                    appViewModel.navigate(to: .productDetail(productId: productId))
                }
            )
        }
        .alert(S.productDeleteTitle, isPresented: $showDeleteAlert) {
            Button(S.actionDelete, role: .destructive) {
                productViewModel.deleteProduct(product)
                appViewModel.navigateBack()
            }
            Button(S.actionCancel, role: .cancel) {}
        } message: {
            Text(S.productDeleteText(product.name))
        }
    }

    private func headerButtons(_ product: Product) -> some View {
        HStack {
            CircleIconButton(icon: "chevron.backward", description: S.actionBack, background: .black.opacity(0.35)) {
                appViewModel.navigateBack()
            }
            Spacer()
            CircleIconButton(
                icon: product.isFavorite ? "star.fill" : "star",
                description: S.favorite,
                background: .black.opacity(0.35),
                foreground: product.isFavorite ? Color(hex: 0xFFC94A) : .white
            ) {
                productViewModel.toggleFavorite(product)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}

#Preview {
    NavigationStack {
        ProductInfoView(productId: "1")
    }
    .environment(AppViewModel())
    .environment(PreviewData.productViewModel)
}
