//
//  ViewController.swift
//  SampleCompositionalLayouts
//
//  Created by Johnny Toda on 2024/01/05.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    /// Cellに表示させるドメインデータを要素とした配列
    private let menuList = ["メニュー1","メニュー2","メニュー3","メニュー4","メニュー5","メニュー6",]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

