import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/post.dart';
import 'package:flutter_application_2/models/user_model.dart';
import 'package:flutter_application_2/page/account_page.dart';
import 'package:flutter_application_2/page/comment.dart';
import 'package:flutter_application_2/page/view_image.dart';
import 'package:flutter_application_2/utils/firebase.dart';
import 'package:flutter_application_2/widgets/cached_image.dart';
import 'package:ionicons/ionicons.dart';

import 'package:like_button/like_button.dart';
// import 'package:ug_blood_donate/models/post.dart';
// import 'package:ug_blood_donate/models/user_model.dart';
// import 'package:ug_blood_donate/screens/profile.dart';
// // import 'package:ug_blood_donate/screens/comment.dart';
// import 'package:ug_blood_donate/screens/view_image.dart';
// import 'package:ug_blood_donate/utils/firebase.dart';
// import 'package:ug_blood_donate/widgets/cached_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class Posts extends StatefulWidget {
  final PostModel? post;

  Posts({this.post});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final DateTime timestamp = DateTime.now();

  currentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  //UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => ViewImage(post: widget.post)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPostHeader(),
            Container(
              height: 320.0,
              width: MediaQuery.of(context).size.width - 18.0,
              child: cachedNetworkImage(widget.post!.mediaUrl!),
            ),
            Flexible(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                title: Text(
                  widget.post!.description! ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 12.0),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        timeago.format(widget.post!.timestamp!.toDate()),
                      ),
                      const SizedBox(width: 3.0),
                      StreamBuilder(
                        stream: likesRef
                            .where('postId', isEqualTo: widget.post!.postId)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot snap = snapshot.data!;
                            List<DocumentSnapshot> docs = snap.docs;
                            return buildLikesCount(context, docs.length ?? 0);
                          } else {
                            return buildLikesCount(context, 0);
                          }
                        },
                      ),
                      const SizedBox(width: 5.0),
                      StreamBuilder(
                        stream: commentRef
                            .doc(widget.post!.postId)
                            .collection("comments")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot snap = snapshot.data!;
                            List<DocumentSnapshot> docs = snap.docs;
                            return buildCommentsCount(
                                context, docs.length ?? 0);
                          } else {
                            return buildCommentsCount(context, 0);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                trailing: Wrap(
                  children: [
                    buildLikeButton(),
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.chat_bubble,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => Comments(post: widget.post),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }

  buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Text(
        '-   $count comments',
        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPostHeader() {
    bool isMe = currentUserId() == widget.post!.ownerId;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      leading: buildUserDp(),
      title: Text(
        widget.post!.username!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.post!.location! ?? 'Wooble',
      ),
      trailing: isMe
          ? IconButton(
              icon: const Icon(Ionicons.ellipsis_horizontal_outline),
              onPressed: () => handleDelete(context),
            )
          : IconButton(
              ///Feature coming soon
              icon: const Icon(CupertinoIcons.bookmark, size: 25.0),
              onPressed: () {},
            ),
    );
  }

  buildUserDp() {
    return StreamBuilder(
      stream: usersRef.doc(widget.post!.ownerId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          UserModel user =
              UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return GestureDetector(
            onTap: () => showProfile(context, profileId: user.uid!),
            child: const CircleAvatar(
              radius: 25.0,
              //backgroundImage: NetworkImage(user.photoUrl!),
            ),
          );
        }
        return Container();
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: likesRef
          .where('postId', isEqualTo: widget.post!.postId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
          return IconButton(
            onPressed: () {
              if (docs.isEmpty) {
                likesRef.add({
                  'userId': currentUserId(),
                  'postId': widget.post!.postId,
                  'dateCreated': Timestamp.now(),
                });
                addLikesToNotification();
              } else {
                likesRef.doc(docs[0].id).delete();
                removeLikeFromNotification();
              }
            },
            icon: docs.isEmpty
                ? const Icon(
                    CupertinoIcons.heart,
                  )
                : const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  ),
          );
        }
        return Container();
      },
    );
  }

  addLikesToNotification() async {
    bool isNotMe = currentUserId() != widget.post!.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      notificationRef
          .doc(widget.post!.ownerId)
          .collection('notifications')
          .doc(widget.post!.postId)
          .set({
        "type": "like",
        "username": user!.name,
        "userId": currentUserId(),
        //"userDp": user!.photoUrl,
        "postId": widget.post!.postId,
        "mediaUrl": widget.post!.mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromNotification() async {
    bool isNotMe = currentUserId() != widget.post!.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      notificationRef
          .doc(widget.post!.ownerId)
          .collection('notifications')
          .doc(widget.post!.postId)
          .get()
          .then((doc) => {
                if (doc.exists) {doc.reference.delete()}
              });
    }
  }

  handleDelete(BuildContext parentContext) {
    //shows a simple dialog box
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deletePost();
                },
                child: const Text('Delete Post'),
              ),
              const Divider(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

//you can only delete your own posts
  deletePost() async {
    postRef.doc(widget.post!.id).delete();

//delete notification associated with that given post
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(widget.post!.ownerId!)
        .collection('notifications')
        .where('postId', isEqualTo: widget.post!.postId)
        .get();
    notificationsSnap.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

//delete all the comments associated with that given post
    QuerySnapshot commentSnapshot =
        await commentRef.doc(widget.post!.postId).collection('comments').get();
    commentSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  showProfile(BuildContext context, {String? profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => AccountPage(), //profileId: profileId
      ),
    );
  }
}
