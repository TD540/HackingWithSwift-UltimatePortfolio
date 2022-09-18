//
//  ItemListView.swift
//  TD Portfolio
//
//  Created by Thomas Decrick on 23/12/2020.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    @Binding var items: ArraySlice<Item>

    func itemButton(for item: Item) -> some View {
        NavigationLink(destination: EditItemView(item: item)) {
            HStack(spacing: 20) {
                Circle()
                    .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading) {
                    Text(item.itemTitle)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if item.itemDetail.isEmpty == false {
                        Text(item.itemDetail)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5)
        }
    }

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items, content: itemButton)
        }
    }
}

// struct ItemListView_Previews: PreviewProvider {
//     static var previews: some View {
//         ItemListView()
//     }
// }
