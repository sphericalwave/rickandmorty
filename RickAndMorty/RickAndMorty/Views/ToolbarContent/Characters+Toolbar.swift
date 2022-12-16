/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The toolbar for the Characters view.
*/

import SwiftUI

extension Characters {

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if editMode == .active {
                SelectButton(mode: $selectMode) {
                    if selectMode.isActive {
                        selection = Set(provider.characters.map { $0.name }) //TODO: check
                    } else {
                        selection = []
                    }
                }
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                selection.removeAll()
                editMode = .inactive
                selectMode = .inactive
            }
        }
        ToolbarItemGroup(placement: .bottomBar) {
            RefreshButton {
                Task {
                    await fetchCharacters()
                }
            }
            Spacer()
            ToolbarStatus(
                isLoading: isLoading,
                lastUpdated: lastUpdated,
                charactersCount: provider.characters.count
            )
            Spacer()
            if editMode == .active {
                DeleteButton {
                    deleteCharacters(for: selection)
                }
                .disabled(isLoading || selection.isEmpty)
            }
        }
    }
}
