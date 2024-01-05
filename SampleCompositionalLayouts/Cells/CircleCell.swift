//
//  CircleCell.swift
//  SampleCompositionalLayouts
//
//  Created by Johnny Toda on 2024/01/05.
//

import UIKit

final class CircleCell: UICollectionViewCell {
    static let nib = UINib(nibName: String(describing: CircleCell.self), bundle: nil)
    static let identifier = String(describing: CircleCell.self)

    // ⚠️この時点ではCellのサイズは決定していない為、awakeFromNib内でレイアウトの設定は避け、layoutSubviews()でレイアウト処理を実装する
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBackgroundView()
    }

    ///  BackgroundViewを生成する
    private func setUpBackgroundView() {
        backgroundView = UIView(frame: super.frame)
        backgroundView?.backgroundColor = .systemCyan
    }
}
