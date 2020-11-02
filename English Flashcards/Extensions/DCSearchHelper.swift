//
//  DCSearchHelper.swift
//  English Flashcards
//
//  Created by QUANG on 3/2/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension DetailCardTVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    //MARK: Search
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCards = cards.filter { card in
            let categoryMatch = (scope == "WORD")
            if categoryMatch { //Word
                //return card.word.lowercased()[0..<searchText.characters.count].contains(searchText.lowercased())
                return card.word.lowercased().contains(searchText.lowercased())
            }
            else { //Category
                return card.definition.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    
    func initiateSearchBar() {
        //For search
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.scopeButtonTitles = ["WORD", "Definition"]
        self.searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = self.searchController.searchBar
    }
    
}
