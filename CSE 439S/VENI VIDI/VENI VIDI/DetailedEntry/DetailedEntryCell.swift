//
//  DetailedEntryCell.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import Cosmos
import DCFrame
import Foundation

class DetailedEntryCell: DCCell<DetailedEntryCellModel>,
    UINavigationControllerDelegate, UIScrollViewDelegate {
    var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    var favorite: Bool = false
    // poster is the larger image for the entry
    let poster: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFit
        poster.backgroundColor = UIColor.systemYellow
        poster.layer.cornerRadius = 10
        poster.clipsToBounds = true
        return poster
    }()

    // user's rating for this movie/book
    let stars: CosmosView = {
        let stars = CosmosView()
        stars.isUserInteractionEnabled = false
        stars.layer.cornerRadius = 4
        return stars
    }()

    let tagView: UIScrollView = {
        let tagView = UIScrollView()
        return tagView
    }()

    let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        return favoriteButton
    }()

    let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        return deleteButton
    }()

    // user's comment for this movie/book
    let comment: NewTextView = {
        let comment = NewTextView()
        comment.textAlignment = .center
        comment.layer.cornerRadius = 10
        comment.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        comment.isEditable = false
        return comment
    }()

    let smallPoster: UIImageView = {
        let smallPoster = UIImageView()
        smallPoster.contentMode = .scaleAspectFit
        smallPoster.backgroundColor = UIColor.systemGray6
        smallPoster.layer.cornerRadius = 6
        smallPoster.clipsToBounds = true
        return smallPoster
    }()

    let quote: NewTextView = {
        let quote = NewTextView()

        quote.textAlignment = .center
        quote.font = UIFont.italicSystemFont(ofSize: 18)
        quote.textColor = UIColor.systemYellow
        quote.isEditable = false

        return quote
    }()

    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.textColor = .systemYellow
        return dateLabel
    }()

    func setFavoriteImage() {
        if favorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    func clearTagView() {
        if !tagView.subviews.isEmpty {
            for subview in tagView.subviews {
                subview.removeFromSuperview()
            }
        }
    }

    func createTags() {
        clearTagView()

        var xOffset: CGFloat = tagView.bounds.minX + 5
        let yOffset: CGFloat = tagView.bounds.minY + 5
        let padding: CGFloat = 5

        if !cellModel.tags.isEmpty {
            for string in cellModel.tags {
                let tagLabel = UILabel()
                tagLabel.text = string

                tagLabel.frame = CGRect(x: xOffset, y: yOffset, width: tagLabel.intrinsicContentSize.width + 5, height: 30)
                xOffset += padding + tagLabel.frame.size.width

                tagView.addSubview(tagLabel)
                tagLabel.layer.cornerRadius = 15
                tagLabel.layer.masksToBounds = true
                tagLabel.backgroundColor = .systemGray6
                tagLabel.textColor = .systemBlue
            }
            tagView.contentSize = CGSize(width: xOffset, height: tagView.frame.height)
        }
    }

    @objc
    func deleteEntry() {
        if let entryId = cellModel.id {
            print(entryId)
            let service = DataService(coreDataStack: CoreDataStack())
            _ = service.deleteJournalEntry(withUUID: entryId)
            _ = navigationController.popViewController(animated: true)
        }
    }

    override func setupUI() {
        super.setupUI()

        contentView.addSubview(poster)
        contentView.addSubview(tagView)
        contentView.addSubview(stars)
        contentView.addSubview(favoriteButton)
        setFavoriteImage()
        contentView.addSubview(deleteButton)
        contentView.addSubview(comment)

        contentView.addSubview(smallPoster)
        contentView.addSubview(quote)

        contentView.addSubview(dateLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        print(bounds)
        let left: CGFloat = 15

        smallPoster.frame = CGRect(x: left, y: 80, width: 120, height: 180)

        quote.frame = CGRect(x: left + 135, y: 80, width: bounds.width - 165, height: 125)
        tagView.frame = CGRect(x: left + 135, y: 220, width: bounds.width - 165, height: 40)
        tagView.delegate = self

        stars.frame = CGRect(x: left, y: 285, width: (bounds.width - 90) / 2, height: 30)
        dateLabel.frame = CGRect(x: left + (bounds.width - 90) / 2, y: 285, width: (bounds.width - 90) / 2, height: 30)
        favoriteButton.frame = CGRect(x: left + (bounds.width - 90), y: 285, width: 30, height: 30)
        deleteButton.frame = CGRect(x: left + (bounds.width - 60), y: 285, width: 30, height: 30)
        comment.frame = CGRect(x: left, y: 330, width: bounds.width - 30, height: 335)
    }

    override func cellModelDidUpdate() {
        super.cellModelDidUpdate()
        if let nav = cellModel.nav {
            navigationController = nav
            print(nav.description)
        }
        poster.image = cellModel.posterImage
        smallPoster.image = cellModel.posterImage
        comment.text = cellModel.comment
        quote.text = #" "\#(cellModel.quote)" "#
        favorite = cellModel.favorite
        setFavoriteImage()

        deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchUpInside)

        if let date = cellModel.date {
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            dateLabel.text = formatter1.string(from: date)
        }

        if let rating = cellModel.rating {
            stars.rating = rating
        }

        createTags()
    }
}
