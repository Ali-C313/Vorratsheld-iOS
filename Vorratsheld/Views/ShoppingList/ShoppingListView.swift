//
//  ShoppingListView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ShoppingListView: View {

    @Environment(AppViewModel.self) private var appViewModel
    @State var shoppingListViewModel: ShoppingListViewModel

    @State private var snackbar: SnackbarMessage?

    var body: some View {
        VStack(spacing: 0) {
            ShoppingHeader(
                doneCount: shoppingListViewModel.doneItems.count,
                totalCount: shoppingListViewModel.items.count,
                onBackClick: { appViewModel.navigateBack() },
                onClearDone: { shoppingListViewModel.clearDone() }
            )

            if shoppingListViewModel.items.isEmpty && !shoppingListViewModel.isLoading {
                EmptyShoppingList()
            } else {
                List {
                    ForEach(shoppingListViewModel.openItems) { item in
                        row(item)
                    }
                    if !shoppingListViewModel.doneItems.isEmpty {
                        Section {
                            ForEach(shoppingListViewModel.doneItems) { item in
                                row(item)
                            }
                        } header: {
                            Text("\(S.shoppingDoneSection) (\(shoppingListViewModel.doneItems.count))")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AppColor.onSurfaceVariant)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .animation(.default, value: shoppingListViewModel.items)
            }
        }
        .background(AppColor.background)
        .safeAreaInset(edge: .bottom) {
            AddItemBar { name in
                shoppingListViewModel.addItem(name: name)
            }
        }
        .snackbar($snackbar, bottomPadding: 80)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            shoppingListViewModel.fetchItems()
        }
        .onDisappear {
            shoppingListViewModel.stopListening()
        }
        .onChange(of: shoppingListViewModel.errorMessage) { _, errorMessage in
            if let errorMessage {
                snackbar = SnackbarMessage(text: errorMessage)
                shoppingListViewModel.errorMessage = nil
            }
        }
    }

    private func row(_ item: ShoppingItem) -> some View {
        ShoppingRow(
            item: item,
            onToggle: { shoppingListViewModel.toggleChecked(item) },
            onQuantityChange: { delta in shoppingListViewModel.changeQuantity(item, by: delta) }
        )
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .swipeActions(edge: .trailing) {
            Button(S.actionDelete, systemImage: "trash", role: .destructive) {
                shoppingListViewModel.deleteItem(item)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShoppingListView(shoppingListViewModel: PreviewData.shoppingListViewModel)
    }
    .environment(AppViewModel())
}
