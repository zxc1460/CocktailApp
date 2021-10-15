//
//  FavoriteViewController.swift
//  CocktailApp
//
//

import RIBs
import RxSwift
import UIKit

protocol FavoritePresentableListener: AnyObject {
}

final class FavoriteViewController: UIViewController, FavoritePresentable, FavoriteViewControllable {

    weak var listener: FavoritePresentableListener?
}
