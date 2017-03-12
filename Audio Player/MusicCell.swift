//
//  MusicCell.swift
//  Audio Player
//
//  Created by Anthony on 5/20/16.
//  Copyright © 2016 appalgorithm. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(_ title:String, artist:String?) {
        songName.text = title
        artistName.text = artist
    }
}
