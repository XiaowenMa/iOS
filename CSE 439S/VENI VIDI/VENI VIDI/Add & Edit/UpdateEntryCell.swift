//
//  UpdateEntryCell.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 3/9/21.
//

import Cosmos
import DCFrame
import Foundation
import SnapKit
import WidgetKit

class UpdateEntryCell: DCCell<UpdateEntryCellModel>,
    UITextViewDelegate, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    static let titleText = DCSharedDataID()

    var width: CGFloat = 0

    var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    var favorite: Bool = false

    let poster: UIImageView = {
        let poster = UIImageView()
        poster.alpha = 0.75
        poster.contentMode = .scaleToFill
        poster.clipsToBounds = true
        poster.layer.cornerRadius = 6
        return poster
    }()

    let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        return favoriteButton
    }()

    // user's rating for this movie/book
    let stars: CosmosView = {
        let stars = CosmosView()
        return stars
    }()

    // user's comment for this movie/book
    var comment: UITextView = {
        let comment = UITextView()
        comment.backgroundColor = UIColor.systemGray6
        comment.text = "Placeholder for Notes"
        comment.accessibilityLabel = "Entry Note"
        comment.layer.cornerRadius = 6
        comment.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return comment
    }()

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        return button
    }()

    let submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.backgroundColor = UIColor.systemYellow
        submitButton.setTitle("Finish", for: .normal)
        submitButton.setTitleColor(UIColor.systemGray, for: .normal)
        submitButton.tintColor = UIColor.systemGray
        submitButton.layer.cornerRadius = 6
        return submitButton
    }()

    let commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.text = "Memories: "
        commentLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return commentLabel
    }()

    let quoteLabel: UILabel = {
        let quoteLabel = UILabel()
        quoteLabel.text = "The Quote: "
        quoteLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return quoteLabel
    }()

    let quote: NewTextView = {
        let quote = NewTextView()
        quote.text = "This is a quotation:)"
        quote.textAlignment = .center
        quote.backgroundColor = .systemGray6
        quote.font = UIFont.italicSystemFont(ofSize: 18)
        quote.textColor = .systemYellow
        return quote
    }()

    let tagView: UIScrollView = {
        let tagView = UIScrollView()
        tagView.backgroundColor = .systemGray6
        tagView.layer.cornerRadius = 6
        return tagView
    }()

    override func setupUI() {
        super.setupUI()

        comment.delegate = self

        contentView.addSubview(poster)
        contentView.addSubview(favoriteButton)

        contentView.addSubview(button)
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(uploadData), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteEntry), for: .touchUpInside)
        setFavoriteImage()
        contentView.addSubview(stars)
        contentView.addSubview(commentLabel)
        contentView.addSubview(comment)
        contentView.addSubview(quoteLabel)
        contentView.addSubview(quote)
        contentView.addSubview(submitButton)

        contentView.addSubview(tagView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        width = contentView.bounds.width
        print(width)

        poster.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.height.equalTo(240)
            make.width.equalTo(135)
            make.left.equalTo(15)
        }

        tagView.snp.makeConstraints { make in
            make.top.equalTo(poster.snp.bottom).offset(-110)
            make.height.equalTo(110)
            make.width.equalToSuperview().offset(-180)
            make.right.equalTo(-15)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(poster.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalTo(-15)
        }

        button.snp.makeConstraints { make in
            make.edges.equalTo(poster.snp.edges)
        }

        button.imageView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50 * 806 / 980)
        }

        stars.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(poster.snp.bottom).offset(20)
            make.left.equalTo(15)
        }

        quoteLabel.snp.makeConstraints { make in
            make.top.equalTo(stars.snp.bottom).offset(20)
            make.height.equalTo(24)
            make.left.equalTo(15)
        }

        quote.snp.makeConstraints { make in
            make.top.equalTo(quoteLabel.snp.bottom).offset(20)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(quote.snp.bottom).offset(20)
            make.height.equalTo(24)
            make.left.equalTo(15)
        }

        comment.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(20)
            make.left.equalTo(comment.snp.left)
            make.height.equalTo(50)
            make.width.equalTo(comment.snp.width)
            make.centerX.equalToSuperview()
        }
    }

    override func cellModelDidLoad() {
        super.cellModelDidLoad()
        subscribeEvent(SearchCell.cancelSearch) { [weak self] (text: String) in
            self?.cellModel.entryTitle = text
        }.and(SearchCM.searchNotEmpty) { [weak self] in
            self?.submitButton.setTitleColor(.black, for: .normal)
        }.and(SearchCM.searchEmpty) { [weak self] in
            self?.submitButton.setTitleColor(.systemGray, for: .normal)
        }.and(SearchResultCell.selectedVolume) { [weak self] (volume: EntryData) in
            let str = volume.url.replacingOccurrences(of: "http:", with: "https:")
            guard let url = URL(string: str) else { return }

            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.poster.image = UIImage(data: data)
                }
            }

            guard let type = volume.type else { return }

            self?.cellModel.type = JournalEntryType(rawValue: type) ?? .none

            task.resume()
        }
    }

    override func cellModelDidUpdate() {
        print("Updating cell model")
        super.cellModelDidUpdate()
        if let nav = cellModel.nav {
            navigationController = nav
            print(nav.description)
        }

        poster.image = cellModel.posterImage
        comment.text = cellModel.comment
        quote.text = cellModel.quote
        stars.rating = cellModel.rating ?? 0
        favorite = cellModel.favorite
        setFavoriteImage()
        createTagView()
    }

    func clearTagView() {
        if !tagView.subviews.isEmpty {
            for subview in tagView.subviews {
                subview.removeFromSuperview()
            }
        }
        print(tagView.subviews.count)
    }

    func createTagView() {
        clearTagView()

        var xOffset: CGFloat = tagView.bounds.minX + 5
        var yOffset: CGFloat = tagView.bounds.minY + 5
        let padding: CGFloat = 5
        if !cellModel.tags.isEmpty {
            print("There are \(cellModel.tags.count) tags")
            for string in cellModel.tags {
                let tagLabel = UILabel()

                tagLabel.backgroundColor = .white
                tagLabel.text = string
                tagLabel.textColor = .systemBlue
                print("contentView width is \(contentView.frame.width)")
                if xOffset + tagLabel.intrinsicContentSize.width + 20 >= 210 {
                    xOffset = tagView.bounds.minX + 5
                    yOffset += 35
                }

                let tagV = CustomTagView()
                tagView.addSubview(tagV)

                tagV.frame = CGRect(x: xOffset, y: yOffset, width: tagLabel.intrinsicContentSize.width + 20, height: 30)
                tagV.backgroundColor = .white
                tagV.layer.cornerRadius = 15
                tagV.layer.masksToBounds = true
                tagV.tagLabel.frame = CGRect(x: 0, y: 0, width: tagLabel.intrinsicContentSize.width + 5, height: 30)
                tagV.tagLabel.text = tagLabel.text
                tagV.tagLabel.textColor = .systemBlue
                tagLabel.layer.cornerRadius = 15
                tagLabel.layer.masksToBounds = true

                tagV.cancel.frame = CGRect(x: tagV.bounds.width - 20, y: 0, width: 15, height: 15)
                tagV.cancel.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
                tagV.cancel.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)

                xOffset += padding + tagLabel.intrinsicContentSize.width + 20
            }
        }
        let addButton = UIButton()
        tagView.addSubview(addButton)
        if xOffset + 30 >= width - 180 {
            xOffset = 5
            yOffset += 35
        }
        addButton.frame = CGRect(x: xOffset, y: yOffset, width: 30, height: 30)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.backgroundColor = .systemGray4
        addButton.layer.cornerRadius = 15

        addButton.addTarget(self, action: #selector(addTag(_:)), for: .touchUpInside)
        tagView.contentSize = CGSize(width: width - 180, height: yOffset + 35)
    }

    @objc
    func removeTag(_ sender: UIButton) {
        var string: String = ""
        if let csTag = sender.superview as? CustomTagView {
            string = csTag.tagLabel.text ?? ""
        }
        sender.superview?.removeFromSuperview()
        cellModel.tags = cellModel.tags.filter { $0 != string }
        print(cellModel.tags.count)
        createTagView()
    }

    @objc
    func addTag(_ sender: UIButton) {
        let count = tagView.subviews.count
        var xCor = sender.frame.minX
        var yCor = sender.frame.minY
        print(tagView.subviews[count - 1].description)

        sender.removeFromSuperview()

        let newTag = CustomTagView()
        newTag.tagLabel.delegate = self
        tagView.addSubview(newTag)

        if xCor + 80 >= width - 180 {
            xCor = 5
            yCor += 35
        }

        newTag.frame = CGRect(x: xCor, y: yCor, width: 80, height: 30)
        newTag.layer
            .cornerRadius = 15
        newTag.tagLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        newTag.tagLabel.textColor = .systemBlue
        newTag.layer.cornerRadius = 15
        newTag.layer.masksToBounds = true

        newTag.cancel.frame = CGRect(x: newTag.bounds.width - 20, y: 0, width: 15, height: 15)
        newTag.cancel.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        newTag.cancel.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)

        newTag.backgroundColor = .white
        newTag.tagLabel.becomeFirstResponder()

        xCor += 85
        let addButton = UIButton()
        tagView.addSubview(addButton)
        addButton.frame = CGRect(x: xCor, y: yCor, width: 30, height: 30)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.backgroundColor = .systemGray4
        addButton.layer.cornerRadius = 15

        addButton.addTarget(self, action: #selector(addTag(_:)), for: .touchUpInside)

        tagView.contentSize = CGSize(width: width - 180, height: yCor + 35)
        print(tagView.subviews.count)
    }

    func setFavoriteImage() {
        if favorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    @objc
    func favoriteEntry() {
        if favorite {
            favorite = false
            setFavoriteImage()
        } else {
            favorite = true
            setFavoriteImage()
        }
    }

    @objc
    func pickImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        navigationController.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let photo = info[.editedImage] as? UIImage else { return }

        poster.image = photo

        navigationController.dismiss(animated: true)

        button.setTitle("", for: .normal)
    }

    @objc
    func uploadData() {
        var newTitle: String
        var newImage: UIImage?
        var newContent: String
        var newQuote: String

        newTitle = cellModel.entryTitle

        newImage = poster.image ?? UIImage(named: "logo_backgruond")

        if let content = comment.text {
            newContent = content
        } else {
            newContent = ""
        }

        if let quote = quote.text {
            newQuote = quote
        } else {
            newQuote = ""
        }

        var newTags: [Tag] = []
        for subview in tagView.subviews {
            print(subview.description)
            if let tagV = subview as? CustomTagView {
                if let text = tagV.tagLabel.text {
                    if text != "" {
                        let tag = cellModel.service.createNewTag(text)
                        newTags.append(tag)
                    }
                }
            }
        }

        guard newTitle != "" else { return }

        _ = cellModel.service.updateJournalEntry(withUUID: cellModel.entryId,
                                                 aboutWork: newTitle,
                                                 withType: cellModel.type,
                                                 withCoverImage: newImage,
                                                 withEntryTitle: newTitle,
                                                 withEntryContent: newContent,
                                                 withQuote: newQuote,
                                                 withTags: newTags,
                                                 withRating: stars.rating,
                                                 isFavorite: favorite)

        let userDefault = UserDefaults(suiteName: "group.BEST-CSE439S-GROUP.VENI-VIDI.widget")
        userDefault?.setValue(newTitle, forKey: "title")
        userDefault?.setValue(newImage?.pngData(), forKey: "cover")
        WidgetCenter.shared.reloadAllTimelines()

        _ = navigationController.popViewController(animated: true)
    }
}
