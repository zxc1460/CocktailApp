//
//  SearchFilterComponent+Filter.swift
//  CocktailApp
//
//

import RIBs

extension SearchFilterComponent: FilterDependency {
    var filterViewController: FilterViewControllable {
        return searchFilterViewController
    }
}

extension SearchFilterComponent: CocktailDetailDependency {}
