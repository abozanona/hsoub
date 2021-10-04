import 'package:flutter/material.dart';
import 'package:hsoub/classes/utils.dart';
import 'package:hsoub/models/comment.dart';
import 'package:hsoub/models/community.dart';
import 'package:hsoub/models/post.dart';
import 'package:hsoub/screens/bloc/home_bloc.dart';
import 'package:hsoub/screens/post_screen.dart';
import 'package:hsoub/themes/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import 'package:delta_markdown/delta_markdown.dart';
import 'package:markdown/markdown.dart' as markdown_lib;

Widget postOuter(Post post, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreen(post.id),
      ));
    },
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              post.user.avatar,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: AppTheme.textStyle(
                    color: const Color(AppTheme.linkText),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: AppTheme.iconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            post.user.fullName,
                            style: AppTheme.textStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.book_outlined,
                            size: AppTheme.iconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            post.community.name,
                            style: AppTheme.textStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            size: AppTheme.iconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            post.commentsNumber,
                            style: AppTheme.textStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: AppTheme.iconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            Utils.formatDateAgo(post.time),
                            style: AppTheme.textStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget communityOuter(Community community, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreen(community.id),
      ));
    },
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(AppTheme.primary),
          ),
        ),
        const SizedBox(width: 20),
        Text(community.name, style: AppTheme.textStyle()),
      ],
    ),
  );
}

class PostComment extends StatefulWidget {
  final Comment comment;
  final BuildContext context;
  const PostComment(this.comment, this.context, {Key? key}) : super(key: key);

  @override
  State<PostComment> createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  bool isAddContent = false;
  Map<int, quill.QuillController> editorKeys = {};

  quill.QuillController getEditorKey(int id) {
    if (!editorKeys.containsKey(id)) {
      editorKeys[id] = quill.QuillController.basic();
    }
    return editorKeys[id]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 2 + 10.0 * widget.comment.level, top: 0, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    commentVotesText(widget.comment.votes),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(
                        widget.comment.user.avatar,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.comment.user.fullName,
                      style: AppTheme.textStyle(),
                    ),
                    const SizedBox(width: 30),
                    const Icon(
                      Icons.access_time_outlined,
                      size: AppTheme.iconSize,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Utils.formatDateAgo(widget.comment.time),
                      style: AppTheme.textStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton(
                      child: const Icon(
                        Icons.more_vert_outlined,
                        size: AppTheme.iconSize,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            "رابط مختصر",
                            style: AppTheme.textStyle(),
                          ),
                          value: 1,
                        ),
                      ],
                      onSelected: (int? value) {
                        if (value == null) {
                          return;
                        }
                        if (value == 1) {
                          String shortUrl = "https://io.hsoub.com/go/${widget.comment.postId}/${widget.comment.id}";
                          FlutterClipboard.copy(shortUrl).then((result) {
                            final snackBar = SnackBar(
                              content: const Text('تم نسخ الرابط المختصر للحافظة'),
                              action: SnackBarAction(
                                label: 'فتح',
                                onPressed: () {
                                  launch(shortUrl);
                                },
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black54,
          ),
          Html(
            data: widget.comment.content,
            style: {
              'body': Style(
                fontFamily: 'cairo',
                fontSize: const FontSize(13),
              )
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HomeBloc.get(context).add(UpvoteCommentEvent(widget.comment.id, widget.comment.postId));
                      },
                      child: const Icon(
                        Icons.arrow_upward_outlined,
                        size: AppTheme.iconSize,
                        color: Color(AppTheme.linkText),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        HomeBloc.get(context).add(DownvoteCommentEvent(widget.comment.id, widget.comment.postId));
                      },
                      child: const Icon(
                        Icons.arrow_downward_outlined,
                        size: AppTheme.iconSize,
                        color: Color(AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isAddContent = !isAddContent;
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.comment_outlined,
                        size: AppTheme.iconSize,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "أضف تعليقاً",
                        style: AppTheme.textStyle(
                          fontSize: 10,
                          color: const Color(AppTheme.linkText),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isAddContent)
            quill.QuillToolbar.basic(
              controller: getEditorKey(widget.comment.id),
              showBoldButton: true,
              showItalicButton: false,
              showSmallButton: false,
              showUnderLineButton: false,
              showStrikeThrough: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showAlignmentButtons: false,
              showHeaderStyle: true,
              showListNumbers: true,
              showListBullets: true,
              showListCheck: false,
              showCodeBlock: false,
              showQuote: true,
              showIndent: false,
              showLink: false,
              showHistory: false,
              showHorizontalRule: false,
              showImageButton: true,
              showVideoButton: false,
              showCameraButton: false,
            ),
          if (isAddContent)
            SizedBox(
              height: 300,
              child: quill.QuillEditor(
                controller: getEditorKey(widget.comment.id),
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: FocusNode(),
                autoFocus: true,
                readOnly: false,
                expands: true,
                padding: const EdgeInsets.all(4),
              ),
            ),
          if (isAddContent)
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(AppTheme.primary).withOpacity(.9),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                overlayColor: MaterialStateProperty.all<Color>(
                  const Color(AppTheme.primary),
                ),
              ),
              onPressed: () {
                HomeBloc.get(context).add(AddCommentOnPostEvent(widget.comment.id, quillDeltaToHtml(getEditorKey(widget.comment.id).document.toDelta())));
              },
              child: Text('تعليق', style: AppTheme.textStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  String quillDeltaToHtml(quill.Delta delta) {
    final convertedValue = jsonEncode(delta.toJson());
    final markdown = deltaToMarkdown(convertedValue);
    final html = markdown_lib.markdownToHtml(markdown);

    return html;
  }
}

commentVotesText(int votes) {
  String votesText = votes.toString();
  if (votes > 0) {
    votesText = "+" + votesText;
  }
  return Text(
    votesText,
    style: AppTheme.textStyle(
      color: votes >= 0 ? const Color(AppTheme.colorVotePositive) : const Color(AppTheme.colorVoteNegative),
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
  );
}

class PostContent extends StatefulWidget {
  final Post post;
  final BuildContext context;
  const PostContent(this.post, this.context, {Key? key}) : super(key: key);

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  bool isAddContent = false;
  Map<int, quill.QuillController> editorKeys = {};

  quill.QuillController getEditorKey(int id) {
    if (!editorKeys.containsKey(id)) {
      editorKeys[id] = quill.QuillController.basic();
    }
    return editorKeys[id]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 2, top: 0, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    commentVotesText(widget.post.votes),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(
                        widget.post.user.avatar,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.post.user.fullName,
                      style: AppTheme.textStyle(),
                    ),
                    const SizedBox(width: 30),
                    const Icon(
                      Icons.access_time_outlined,
                      size: AppTheme.iconSize,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Utils.formatDateAgo(widget.post.time),
                      style: AppTheme.textStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton(
                      child: const Icon(
                        Icons.more_vert_outlined,
                        size: AppTheme.iconSize,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            "رابط مختصر",
                            style: AppTheme.textStyle(),
                          ),
                          value: 1,
                        ),
                      ],
                      onSelected: (int? value) {
                        if (value == null) {
                          return;
                        }
                        if (value == 1) {
                          String shortUrl = "https://io.hsoub.com/go/${widget.post.id}";
                          FlutterClipboard.copy(shortUrl).then((result) {
                            final snackBar = SnackBar(
                              content: const Text('تم نسخ الرابط المختصر للحافظة'),
                              action: SnackBarAction(
                                label: 'فتح',
                                onPressed: () {
                                  launch(shortUrl);
                                },
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black54,
          ),
          Html(
            data: widget.post.content,
            style: {
              'body': Style(
                fontFamily: 'cairo',
                fontSize: const FontSize(13),
              )
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HomeBloc.get(context).add(UpvotePostEvent(widget.post.id));
                      },
                      child: const Icon(
                        Icons.arrow_upward_outlined,
                        size: AppTheme.iconSize,
                        color: Color(AppTheme.linkText),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        HomeBloc.get(context).add(DownvotePostEvent(widget.post.id));
                      },
                      child: const Icon(
                        Icons.arrow_downward_outlined,
                        size: AppTheme.iconSize,
                        color: Color(AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isAddContent = !isAddContent;
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.comment_outlined,
                        size: AppTheme.iconSize,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "أضف تعليقاً",
                        style: AppTheme.textStyle(
                          fontSize: 10,
                          color: const Color(AppTheme.linkText),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isAddContent)
            quill.QuillToolbar.basic(
              controller: getEditorKey(widget.post.id),
              showBoldButton: true,
              showItalicButton: false,
              showSmallButton: false,
              showUnderLineButton: false,
              showStrikeThrough: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showAlignmentButtons: false,
              showHeaderStyle: true,
              showListNumbers: true,
              showListBullets: true,
              showListCheck: false,
              showCodeBlock: false,
              showQuote: true,
              showIndent: false,
              showLink: false,
              showHistory: false,
              showHorizontalRule: false,
              showImageButton: true,
              showVideoButton: false,
              showCameraButton: false,
            ),
          if (isAddContent)
            SizedBox(
              height: 300,
              child: quill.QuillEditor(
                controller: getEditorKey(widget.post.id),
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: FocusNode(),
                autoFocus: true,
                readOnly: false,
                expands: true,
                padding: const EdgeInsets.all(4),
              ),
            ),
          if (isAddContent)
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(AppTheme.primary).withOpacity(.9),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                overlayColor: MaterialStateProperty.all<Color>(
                  const Color(AppTheme.primary),
                ),
              ),
              onPressed: () {
                HomeBloc.get(context).add(AddCommentOnPostEvent(widget.post.id, quillDeltaToHtml(getEditorKey(widget.post.id).document.toDelta())));
              },
              child: Text('تعليق', style: AppTheme.textStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  String quillDeltaToHtml(quill.Delta delta) {
    final convertedValue = jsonEncode(delta.toJson());
    final markdown = deltaToMarkdown(convertedValue);
    final html = markdown_lib.markdownToHtml(markdown);

    return html;
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.text = ''}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getLoadingIndicator(),
          _getHeading(context),
          _getText(displayedText),
        ],
      ),
    );
  }

  Padding _getLoadingIndicator() {
    return const Padding(
      child: SizedBox(
        child: CircularProgressIndicator(strokeWidth: 3),
        width: 32,
        height: 32,
      ),
      padding: EdgeInsets.only(
        bottom: 16,
      ),
    );
  }

  Widget _getHeading(context) {
    return const Padding(
      child: Text(
        'يرجى الإنتظار …',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      padding: EdgeInsets.only(bottom: 4),
    );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }
}
