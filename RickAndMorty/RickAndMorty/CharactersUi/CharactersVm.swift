//
//  CharactersVm.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation
import Combine

class CharactersVm: ObservableObject {
    
    init() {
        loadMoreContent()
    }
    
    @Published var characters: [RMCharacter] = []
    @Published var isShowingAlert = false
    @Published var alertMsg = ""
    @Published var searchText = ""
    //paging
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    //https://www.donnywals.com/implementing-an-infinite-scrolling-list-with-swiftui-and-combine/
    //https://www.donnywals.com/using-custom-publishers-to-drive-swiftui-views/
    //https://www.donnywals.com/whats-the-difference-between-catch-and-replaceerror-in-combine/
    
    private func loadMoreContent() {
        
        print("isLoadingPage \(isLoadingPage) canLoadMorePages \(canLoadMorePages) currentPg \(currentPage)")
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(currentPage)")!

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GetRMCharacterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                
                print("response.info.next != nil \(response.info.next != nil)")
                print(response.results.first?.name ?? "name?")
                
                self.canLoadMorePages = response.info.next != nil  //TODO: check assumption
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map { response in
                
                return self.characters + response.results
            }
            .catch { _ in
                Just(self.characters)
            }
            .assign(to: &$characters)
    }
    
    func loadMoreContentIfNeeded(currentItem item: RMCharacter?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
//    func fetchCharacters() {
//        let api = RickAndMortyApi()
//        Task {
//            do {
//                let response = try await api.getCharacters()
//                DispatchQueue.main.async { [weak self] in
//                    self?.characters = response.results
//                }
//            }
//            catch {
//                DispatchQueue.main.async { [weak self] in
//                    print(error)
//                    self?.alertMsg = error.localizedDescription.debugDescription
//                    self?.isShowingAlert = true
//                }
//            }
//        }
//    }
    
    var searchResults: [RMCharacter] {
        if searchText.isEmpty {
            return characters
        }
        else {
            return characters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
                
            }
        }
    }
}
