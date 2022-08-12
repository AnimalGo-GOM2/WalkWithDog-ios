//
//  FilterBreedCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class FilterBreedCell: UICollectionViewCell {
  
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var breedLabel: UILabel!
  @IBOutlet weak var breedView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.breedView.setCornerRadius(radius: 14)
    self.breedView.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
  }
}
