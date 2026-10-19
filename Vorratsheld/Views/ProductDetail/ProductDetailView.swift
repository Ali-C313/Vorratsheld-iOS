//
//  ProductDetailView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ProductDetailView: View {

    let productId: String
    let barcode: String

    @Environment(AppViewModel.self) private var appViewModel
    @Environment(ProductViewModel.self) private var productViewModel
    @Environment(UserViewModel.self) private var userViewModel
    @State var productDetailViewModel: ProductDetailViewModel

    @State private var didLoad = false
    @State private var showDatePicker = false
    @State private var showDeleteAlert = false
    @State private var showExpiryScan = false

    var body: some View {
        Form {
            Section {
                HStack {
                    TextField(S.productName, text: $productDetailViewModel.name)
                    if productDetailViewModel.isLoading {
                        ProgressView()
                    }
                }
            }

            Section(S.productLocation) {
                Picker(S.productLocation, selection: $productDetailViewModel.location) {
                    ForEach(StorageLocation.allCases) { location in
                        Text(location.label).tag(location)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            Section {
                quantityRow
            }

            Section(S.productExpiry) {
                expiryButtons
            }

            Section {
                Button {
                    productDetailViewModel.isFavorite.toggle()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: productDetailViewModel.isFavorite ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundStyle(productDetailViewModel.isFavorite ? AppColor.favorite : AppColor.onSurfaceVariant)
                        Text(S.productFavoriteHint)
                            .font(.footnote)
                            .foregroundStyle(AppColor.onSurface)
                    }
                }
                .accessibilityLabel(S.favorite)
            }

            if let errorMessage = productDetailViewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(AppColor.error)
                }
            }

            Section {
                PrimaryButton(text: productDetailViewModel.isEditMode ? S.actionSave : S.actionAdd) {
                    save()
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
        }
        .navigationTitle(productDetailViewModel.isEditMode ? S.productEditTitle : S.productNewTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if productDetailViewModel.isEditMode {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(S.actionDelete, systemImage: "trash", role: .destructive) {
                        showDeleteAlert = true
                    }
                }
            }
        }
        .alert(S.productDeleteTitle, isPresented: $showDeleteAlert) {
            Button(S.actionDelete, role: .destructive) {
                if let product = productViewModel.product(withId: productId) {
                    productViewModel.deleteProduct(product)
                }
                // Die Produktansicht dahinter gibt es dann nicht mehr
                appViewModel.navigateToRoot()
            }
            Button(S.actionCancel, role: .cancel) {}
        } message: {
            Text(S.productDeleteText(productDetailViewModel.name))
        }
        .sheet(isPresented: $showDatePicker) {
            ExpiryDatePickerSheet(expiryDate: productDetailViewModel.expiryDate) { date in
                productDetailViewModel.expiryDate = date
            }
        }
        .fullScreenCover(isPresented: $showExpiryScan) {
            ExpiryScanOverlay(
                onDateConfirmed: { date in
                    productDetailViewModel.expiryDate = date
                    showExpiryScan = false
                },
                onManualPick: {
                    showExpiryScan = false
                    // Kalender erst öffnen, wenn die Kamera zu ist
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showDatePicker = true
                    }
                },
                onClose: {
                    showExpiryScan = false
                }
            )
        }
        .onAppear {
            loadOnce()
        }
    }

    private var quantityRow: some View {
        HStack {
            Text(S.productQuantity)
            Spacer()
            Button {
                productDetailViewModel.changeQuantity(by: -1)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
            }
            .disabled(productDetailViewModel.quantity <= 1)
            Text("\(productDetailViewModel.quantity)")
                .font(.title3.bold())
                .frame(minWidth: 36)
                .contentTransition(.numericText(value: Double(productDetailViewModel.quantity)))
            Button {
                productDetailViewModel.changeQuantity(by: 1)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .buttonStyle(.borderless)
        .animation(.default, value: productDetailViewModel.quantity)
    }

    private var expiryButtons: some View {
        HStack(spacing: 8) {
            Button {
                showDatePicker = true
            } label: {
                Label(DateHelper.formatDate(productDetailViewModel.expiryDate), systemImage: "calendar")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                showExpiryScan = true
            } label: {
                Label(S.expiryScanButton, systemImage: "doc.text.viewfinder")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
    }

    // Nur beim ersten Mal laden
    private func loadOnce() {
        guard !didLoad else { return }
        didLoad = true

        if let product = productViewModel.product(withId: productId) {
            productDetailViewModel.load(product)
        } else if !barcode.isEmpty {
            productDetailViewModel.loadForNewScan(barcode: barcode)
            // Nach dem Barcode gleich das MHD scannen
            showExpiryScan = true
        }
    }

    private func save() {
        guard let userId = userViewModel.userId else { return }
        productViewModel.saveProduct(productDetailViewModel.makeProduct(userId: userId))
        appViewModel.navigateBack()
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(productId: "", barcode: "4008400301012", productDetailViewModel: PreviewData.productDetailViewModel)
    }
    .environment(AppViewModel())
    .environment(PreviewData.userViewModel)
    .environment(PreviewData.productViewModel)
}
