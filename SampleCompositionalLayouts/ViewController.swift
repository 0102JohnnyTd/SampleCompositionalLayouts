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

    /// DiffableDataSourceに追加するItemを管理
    private enum Item: Hashable {
        case menu(String)
    }

    // DiffableDataSourceに追加するSectionを管理
    private enum Section: Int, CaseIterable {
        case circleMenuList
        case rectangleMenuList

        // Sectionごとの列数を返す
        var columnCount: Int {
            switch self {
            case .circleMenuList:
                return 1
            case .rectangleMenuList:
                return 1
            }
        }
    }

    ///  CollectionViewに表示するデータを管理
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController {
    /// CollectionViewのレイアウトを構築する
    private func createLayout() -> UICollectionViewLayout {
        // UICollectionViewCompositionalLayoutクラスのインスタンスを作成
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // indexに該当するセクションにアクセスする
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            // セクションの列数を定義
            let columnCount = sectionKind.columnCount

            // セクションごとにレイアウトを条件分岐
            switch sectionKind {
            case .circleMenuList:
                // MARK: - Itemを作成
                // Itemのサイズを設定
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.2)
                )
                // Itemのクラスインスタンスを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // MARK: - Groupを作成
                // Groupのサイズを設定
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .fractionalHeight(0.2)
                )
                // Groupのクラスインスタンスを生成
                // TODO: iOS15.9以下のユーザーをフォローすると⇩のようにコード長くなってしまう。しかもgroupの生成処理以降は同じコードなので非常に冗長。でもどっちもdeprecatedの書き方でやるのはどうなんだろうという思いもあり..
                if #available(iOS 16.0, *) {
                    // 横スクロールな
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize, // groupのサイズ
                        repeatingSubitem: item, // group内で表示させるItem
                        count: columnCount // 列の数
                    )
                    // MARK: - Sectionを作成
                    // sectionのインスタンスを生成
                    let section = NSCollectionLayoutSection(group: group)
                    // section間のスペースを設定
                    section.interGroupSpacing = 10
                    // スクロール方向を指定
                    section.orthogonalScrollingBehavior = .continuous
                    // sectionの上下左右間隔を指定
                    section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                    return section
                } else {
                    // iOS16未満ユーザー向けの実装
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize,
                        subitem: item,
                        count: columnCount
                    )
                    // MARK: - Sectionを作成
                    // sectionのインスタンスを生成
                    let section = NSCollectionLayoutSection(group: group)
                    // section間のスペースを設定
                    section.interGroupSpacing = 10
                    // スクロール方向を指定
                    section.orthogonalScrollingBehavior = .continuous
                    // sectionの上下左右間隔を指定
                    section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                    return section
                }
            case .rectangleMenuList:
                // MARK: - Itemを作成
                // Itemのサイズを設定
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)
                )
                // Itemのインスタンスを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // MARK: - Groupを作成
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.2)
                )
//                let group = NSCollectionLayoutGroup(layoutSize: groupSize)
                if #available(iOS 16.0, *) {
                    // Groupのインスタンスを生成
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize, // groupのサイズを指定
                        repeatingSubitem: item, // group内で表示させるItem
                        count: sectionKind.columnCount // 列の数
                    )
                    // MARK: - Sectionを作成
                    // Sectionのインスタンスを生成
                    let section = NSCollectionLayoutSection(group: group)
                    // section間のスペースを設定
                    section.interGroupSpacing = 8
                    // sectionの上下左右間隔を指定
                    section.contentInsets = .init(
                        top: 8,
                        leading: 8,
                        bottom: 8,
                        trailing: 8
                    )
                    return section
                } else {
                    // Groupのインスタンスを生成
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize,
                        subitem: item,
                        count: sectionKind.columnCount
                    )
                    // MARK: - Sectionを作成
                    // Sectionのインスタンスを生成
                    let section = NSCollectionLayoutSection(group: group)
                    // section間のスペースを設定
                    section.interGroupSpacing = 8
                    // sectionの上下左右間隔を指定
                    section.contentInsets = .init(
                        top: 8,
                        leading: 8,
                        bottom: 8,
                        trailing: 8
                    )
                    return section
                }
            }
        }
        return layout
    }
}

extension ViewController {
//    /// 画面起動時にDataSourceにデータを登録
    private func applyInitialSnapshots(menuList: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
        let menuListItems = menuList.map { Item.menu($0) }

        var circleMenuListSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        circleMenuListSnapshot.append(menuListItems)
        dataSource.apply(circleMenuListSnapshot, to: .circleMenuList, animatingDifferences: true)

        var rectangleMenuListSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        rectangleMenuListSnapshot.append(menuListItems)
        dataSource.apply(rectangleMenuListSnapshot, to: .rectangleMenuList, animatingDifferences: true)
    }
}
