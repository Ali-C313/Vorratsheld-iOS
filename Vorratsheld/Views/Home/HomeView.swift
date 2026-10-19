//
//  HomeView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct HomeView: View {

    @Environment(AppViewModel.self) private var appViewModel
    @Environment(UserViewModel.self) private var userViewModel
    @Environment(ProductViewModel.self) private var productViewModel

    @State private var selectedLocation: StorageLocation = .kuehlschrank
    @State private var snackbar: SnackbarMessage?

    private var filteredProducts: [Product] {
        productViewModel.products
            .filter { $0.location == selectedLocation }
            .sorted { $0.expiryDate < $1.expiryDate }
    }

    private var urgencies: [ExpiryUrgency] {
        productViewModel.products.map { DateHelper.expiryUrgency(for: $0.expiryDate) }
    }

    var body: some View {
        VStack(spacing: 0) {
            OverviewHeader(
                firstName: userViewModel.user?.firstName ?? "",
                fullName: userViewModel.user?.fullName ?? "",
                photoBase64: userViewModel.user?.photoBase64,
                expiredCount: urgencies.filter { $0 == .abgelaufen }.count,
                soonCount: urgencies.filter { $0 == .baldAblaufend }.count,
                totalCount: productViewModel.products.count,
                onShoppingListClick: { appViewModel.navigate(to: .shoppingList) },
                onSettingsClick: { appViewModel.navigate(to: .settings) }
            )

            Picker(S.productLocation, selection: $selectedLocation) {
                ForEach(StorageLocation.allCases) { location in
                    Text(location.label).tag(location)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if filteredProducts.isEmpty {
                ScrollView {
                    OverviewEmptyState {
                        appViewModel.navigate(to: .scan)
                    }
                }
            } else {
                List(filteredProducts) { product in
                    productRow(product)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .contentMargins(.bottom, 96, for: .scrollContent)
            }
        }
        .background(AppColor.background)
        .overlay(alignment: .bottomTrailing) {
            scanButton
        }
        .snackbar($snackbar, bottomPadding: 88)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            productViewModel.fetchProducts()
        }
        .onChange(of: productViewModel.errorMessage) { _, errorMessage in
            if let errorMessage {
                snackbar = SnackbarMessage(text: errorMessage)
                productViewModel.errorMessage = nil
            }
        }
    }

    private var scanButton: some View {
        Button {
            appViewModel.navigate(to: .scan)
        } label: {
            Label(S.overviewScan, systemImage: "barcode.viewfinder")
                .font(.headline)
                .foregroundStyle(AppColor.onPrimary)
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(AppColor.primary, in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
        }
        .padding(16)
    }

    private func productRow(_ product: Product) -> some View {
        ProductCard(product: product) {
            productViewModel.toggleFavorite(product)
            snackbar = SnackbarMessage(text: S.overviewFavoriteUpdated(product.name))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            appViewModel.navigate(to: .productInfo(productId: product.id ?? ""))
        }
        .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .swipeActions(edge: .trailing) {
            Button(S.actionDelete, systemImage: "trash", role: .destructive) {
                delete(product)
            }
            Button(S.actionEdit, systemImage: "pencil") {
                appViewModel.navigate(to: .productDetail(productId: product.id ?? ""))
            }
            .tint(AppColor.secondary)
        }
    }

    private func delete(_ product: Product) {
        productViewModel.deleteProduct(product)
        snackbar = SnackbarMessage(
            text: product.isFavorite ? S.productDeletedToList(product.name) : S.productDeleted(product.name),
            actionLabel: S.actionUndo,
            action: { productViewModel.restoreProduct(product) }
        )
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppViewModel())
    .environment(PreviewData.userViewModel)
    .environment(PreviewData.productViewModel)
}
