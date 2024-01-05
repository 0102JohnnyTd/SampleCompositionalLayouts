//
//  RectangleCell.swift
//  SampleCompositionalLayouts
//
//  Created by Johnny Toda on 2024/01/05.
//

import UIKit

final class RectangleCell: UICollectionViewCell {
    @IBOutlet private weak var menuLabel: UILabel!
    static let nib = UINib(nibName: String(describing: RectangleCell.self), bundle: nil)
    static let identifier = String(describing: RectangleCell.self)

    // ⚠️この時点ではCellのサイズは決定していない為、awakeFromNib内でレイアウトの設定は避け、layoutSubviews()でレイアウト処理を実装する
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBackgroundView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

    ///  BackgroundViewを生成する
    private func setUpBackgroundView() {
        backgroundView = UIView(frame: super.frame)
        backgroundView?.backgroundColor = .systemRed
    }

    func configure(menu: String) {
        menuLabel.text = menu
    }
}
