//
//  TrackCell.swift
//  iMusic
//
//  Created by CodergirlTM on 24.01.22.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}
class TrackCell: UITableViewCell {

    static let reuseId = "TrackCell"
    
    @IBOutlet weak var favTrack: UIButton!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil
    }
    @IBAction func addTrack(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        favTrack.isHidden = true
        var listOfTracks = defaults.savedTracks()

        listOfTracks.append(cell)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            print("succesfully")
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    var cell: SearchViewModel.Cell?
    
    func setModel(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite {
            favTrack.isHidden = true
        } else {
            favTrack.isHidden = false
        }
    }
    
}
