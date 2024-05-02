//
//  WCChatWithViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 4.04.2024.
//

import UIKit
import MessageKit
import FirebaseAuth

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class WCChatWithViewController: MessagesViewController {

//    let chatView = WCChatWithView()
    var user: WCContact!
    var roomid: String? {
        didSet {
            WCFirabaseCRUD.shared.getMessages(roomid: roomid ?? "") { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let messagesFromFirebase):
                    strongSelf.messages.removeAll()
                    for message in messagesFromFirebase {
                        if message.reciever == strongSelf.selfSender.senderId {
                            let m = Message(sender: Sender(senderId: message.sender, displayName: ""), messageId: "", sentDate: message.date.dateValue(), kind: .text(message.text))
                            strongSelf.messages.append(m)
                        }else {
                            let m = Message(sender: strongSelf.selfSender, messageId: "", sentDate: message.date.dateValue(), kind: .text(message.text))
                            strongSelf.messages.append(m)
                        }
                    }
                    strongSelf.messagesCollectionView.reloadData()
                    strongSelf.messagesCollectionView.scrollToBottom(animated: true)
                case .failure:
                    break
                }
            }
        }
    }
    
    private let selfSender = Sender(senderId: Auth.auth().currentUser?.phoneNumber ?? "", displayName: Auth.auth().currentUser?.phoneNumber ?? "")
    private var messages: [Message] = []
    
    init(user: WCContact) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let phoneBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "phone"), style: .plain, target: nil, action: nil)
        let cameraBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [cameraBarButtonItem,phoneBarButtonItem]
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        WCFirabaseCRUD.shared.checkRoom(receiver: user.phoneNumber) { [weak self] roomid in
            self?.roomid = roomid
        }
        
        
        
        messageInputBar.sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        messageInputBar.sendButton.title = ""
        messagesCollectionView.backgroundView = UIImageView(image: UIImage(named: "wallpaper1"))
//        view.addSubview(chatView)
        view.backgroundColor = .systemBackground
//        setUpConstraints()
        let titleView =  ImageTextNavBarView(frame: .zero)
        
        if let data = Data(base64Encoded: user.image ?? "", options: .ignoreUnknownCharacters),let image = UIImage(data: data) {
            titleView.setImage(image, text: user.name)
        }else{
            titleView.setImage(UIImage(systemName: "circle.fill")!.withTintColor(.black), text: user.name)
        }
        titleView.sizeToFit()
        navigationItem.titleView = titleView
        
        messageInputBar.inputTextView.layer.borderWidth = 0.3
        messageInputBar.inputTextView.layer.cornerRadius = 15
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        

        messageInputBar.sendButton.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
    }
    
    
//    private func setUpConstraints() {
//        NSLayoutConstraint.activate([
//            chatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            chatView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            chatView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
    
    
    @objc private func sendButtonDidTap() {
        guard let roomid = roomid else { return }
        let message = WCMessage(roomid: roomid,text: messageInputBar.inputTextView.text, reciever: user.phoneNumber, date: .init(date: .now), sender: Auth.auth().currentUser?.phoneNumber ?? "")
        WCFirabaseCRUD.shared.sendMessage(message)
        messageInputBar.inputTextView.text = ""

    }

}

extension WCChatWithViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        print("count: \(messages.count)")
//       print("section: \(indexPath.section)")
//        if message.sender.senderId == Auth.auth().currentUser?.phoneNumber ?? "" {
//            avatarView.image = UIImage(named: "eyubi")
//        }else {
//            if messages.count >= indexPath.section + 1 {
//                if messages[indexPath.section + 1].sender.senderId == message.sender.senderId {
//                    avatarView.removeFromSuperview()
//                }else{
//                    if let data = Data(base64Encoded: user.image ?? "", options: .ignoreUnknownCharacters) {
//                        avatarView.image = UIImage(data: data)
//                    }
//
//                }
//
//            }
//        }
//
//    }
    
    
}

class ImageTextNavBarView: UIView {

  let imageView: UIImageView
  let titleLabel: UILabel

  override init(frame: CGRect) {
    imageView = UIImageView(frame: .zero)
    titleLabel = UILabel(frame: .zero)
      
      
    super.init(frame: frame)
    backgroundColor = .red
    // Configure image and label properties here (e.g., size, content mode)
    imageView.contentMode = .scaleAspectFit
    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
      

    // Add image and label views as subviews
    addSubview(imageView)
    addSubview(titleLabel)
      
    // Layout the subviews using constraints or auto layout
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
      imageView.layer.cornerRadius = 40 / 2
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true

    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -180),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
      imageView.heightAnchor.constraint(equalToConstant: 40),
      imageView.widthAnchor.constraint(equalToConstant: 40),

      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
      titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
      
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Set image and text programmatically
  func setImage(_ image: UIImage, text: String) {
    imageView.image = image
    titleLabel.text = text
  }
    
    @objc func imageDidTap() {
        print("tıklandı!")
    }
    
}
