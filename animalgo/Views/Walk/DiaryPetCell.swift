//
//  PetImageCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/11.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class DiaryPetCell: UICollectionViewCell {
  @IBOutlet weak var petImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    self.petImageView.setCornerRadius(radius: 34)
    self.petImageView.addBorder(width: 2, color: UIColor(named: "FFFFFF")!)
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
  }
  private func setupViews() {
    
    self.backgroundColor =  .clear
    contentView.backgroundColor = .clear
    
    // Hero Image
    contentView.addSubview(petImageView)
    petImageView.snp.remakeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    petImageView.layer.cornerRadius = 34
    petImageView.layer.borderColor = UIColor.white.cgColor
    petImageView.layer.borderWidth = 2
    petImageView.clipsToBounds = true
    petImageView.contentMode = .scaleAspectFill
    
  }
  
}
