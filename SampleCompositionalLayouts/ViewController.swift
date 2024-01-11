//
//  ViewController.swift
//  SampleCompositionalLayouts
//
//  Created by Johnny Toda on 2024/01/05.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    /// CircleCellに表示させるドメインデータを要素とした配列
    private let gorillaList = ["1ごりら","2ごりら","3ごりら","4ごりら","5ごりら","6ごりら",]
    /// RecangleCellに表示させるドメインデータを要素とした配列
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
        setUpCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureHierarchy()
    }

    private func setUpCollectionView() {
//        configureHierarchy()
        configureDataSource()
        applyInitialSnapshots(menuList: menuList)
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
    }

    /// データソースを構築
    private func configureDataSource() {
        // MARK: - Cellの登録
        let circleCellRegistration = UICollectionView.CellRegistration<CircleCell, Item>(cellNib: CircleCell.nib) { cell, _, item in
            switch item {
            case .menu(let menu):
//                cell.layer.cornerRadius = cell.frame.width * 0.5
                cell.configure(menu: menu)
            }
        }
        let rectangleCellRegistration = UICollectionView.CellRegistration<RectangleCell, Item>(cellNib: RectangleCell.nib) { cell, _, item in
            switch item {
            case .menu(let menu):
                cell.configure(menu: menu)
            }
        }
        // MARK: - DataSourceの構築
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .circleMenuList:
                return collectionView.dequeueConfiguredReusableCell(
                    using: circleCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .rectangleMenuList:
                return collectionView.dequeueConfiguredReusableCell(
                    using: rectangleCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
}

extension ViewController {
    /// CollectionViewのレイアウトを構築する
    private func createLayout() -> UICollectionViewLayout {
        // UICollectionViewCompositionalLayoutクラスのインスタンスを作成
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // indexに該当するセクションにアクセスする
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            // セクションの列数を定義
            let columnCount = sectionKind.columnCount

            let section: NSCollectionLayoutSection

            // セクションごとにレイアウトを条件分岐
            switch sectionKind {
            case .circleMenuList:
                // MARK: - Itemを作成
                // Itemのサイズを設定
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                // Itemのクラスインスタンスを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Itemの上下左右間隔を指定
                item.contentInsets = .init(
                    top: 0,
                    leading: 4,
                    bottom: 4,
                    trailing: 4
                )
                // MARK: - Groupを作成
                // Groupのサイズを設定
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .fractionalHeight(0.1)
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
                    section = NSCollectionLayoutSection(group: group)
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
                    section = NSCollectionLayoutSection(group: group)
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
                    heightDimension: .fractionalWidth(0.2)
                )
                // Itemのインスタンスを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Itemの上下左右間隔を指定
                item.contentInsets = .init(
                    top: 4,
                    leading: 4,
                    bottom: 4,
                    trailing: 4
                )
                // MARK: - Groupを作成
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.2)
                )


                func makeGroup() -> NSCollectionLayoutGroup {
                    if #available(iOS 16.0, *) {
                        // Groupのインスタンスを生成
                        return NSCollectionLayoutGroup.horizontal(
                            layoutSize: groupSize, // groupのサイズを指定
                            repeatingSubitem: item, // group内で表示させるItem
                            count: sectionKind.columnCount // 列の数
                        )
                    } else {
                        // Groupのインスタンスを生成
                        return NSCollectionLayoutGroup.horizontal(
                            layoutSize: groupSize,
                            subitem: item,
                            count: sectionKind.columnCount
                        )
                    }
                }

                let group = makeGroup()
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
        return layout
    }
}

extension ViewController {
    /// 画面起動時にDataSourceにデータを登録
    private func applyInitialSnapshots(menuList: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)

        let gorillaListItems = gorillaList.map{ Item.menu($0) }
        let menuListItems = menuList.map { Item.menu($0) }



        var circleMenuListSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        circleMenuListSnapshot.append(gorillaListItems)
        dataSource.apply(circleMenuListSnapshot, to: .circleMenuList, animatingDifferences: true)

        var rectangleMenuListSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        rectangleMenuListSnapshot.append(menuListItems)
        dataSource.apply(rectangleMenuListSnapshot, to: .rectangleMenuList, animatingDifferences: true)
    }
}
