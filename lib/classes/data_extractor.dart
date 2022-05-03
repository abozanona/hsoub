import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hsoub/models/comment.dart';
import 'package:hsoub/models/community.dart';
import 'package:hsoub/models/post.dart';
import 'package:hsoub/models/user.dart';
import 'package:html/parser.dart' show parse;
import 'package:logger/logger.dart';

class DataExtractor {
  static String getLoginLink(String html) {
    var document = parse(html);
    var carfMeta = document.querySelector("meta[name='login_url']");
    if (carfMeta == null) {
      return 'https://io.hsoub.com';
    }
    return 'https://io.hsoub.com' + (carfMeta.attributes['content'] ?? '');
  }

  static String getCSRFToken(String html) {
    var document = parse(html);
    var carfMeta = document.querySelector("meta[name='csrf-token']");
    if (carfMeta == null) {
      return '';
    }
    return carfMeta.attributes['content'] ?? '';
  }

  static List<Community> getCommunities(String html) {
    var document = parse(html);
    List<Community> res = [];
    document.querySelectorAll('.communityCard').forEach((postElement) {
      try {
        Community category = Community();
        category.id = int.parse(postElement.attributes['id']!.replaceAll('community-', ''));
        category.slug = postElement.attributes['data-community-slug']!;
        category.name = postElement.querySelector('.blockW-head')!.text.trim();
        category.description = postElement.querySelector('.cardContent p')!.text.trim();
        category.followers = postElement.querySelector('.communityFollower')!.text.trim();
        category.isfollowing = false;

        res.add(category);
      } catch (ex, trace) {
        var logger = Logger();
        logger.e(ex.toString());
        logger.e(trace.toString());
      }
    });
    return res;
  }

  static List<Post> getPosts(String html) {
    var document = parse(html);
    List<Post> res = [];
    document.querySelectorAll('.post-item').forEach((postElement) {
      try {
        Post post = Post();
        post.id = int.parse(postElement.attributes['id']!.replaceAll('post-', ''));
        post.votes = int.parse(postElement.querySelector('.post_points')!.innerHtml);
        post.time = postElement.querySelector('.fixedTime')!.text.trim();
        post.commentsNumber = postElement.querySelector('.commentsCounter')!.text.trim();
        post.title = postElement.querySelector('.post-item__title')!.text.trim();

        User user = User();
        if (postElement.querySelector('.meta__user .lightBoxUserLnk') == null) {
          user.slug = 'عبد-الحميد';
          user.fullName = 'مجهول';
          user.avatar = 'https://avatars.hsoubcdn.com/default?s=128';
        } else {
          user.slug = postElement.querySelector('.meta__user .lightBoxUserLnk')!.attributes['slug']!;
          user.fullName = postElement.querySelector('.meta__user')!.text.trim();
          user.avatar = postElement.querySelector('.meta__user .lightBoxUserLnk img')!.attributes['src']!;
          post.user = user;
        }
        Community community = Community();
        community.slug = postElement.querySelector('.meta__details li .lightBoxUserLnk')!.attributes['slug']!;
        community.name = postElement.querySelector('.meta__details li .lightBoxUserLnk')!.text.trim();
        post.community = community;

        res.add(post);
      } catch (ex, trace) {
        var logger = Logger();
        logger.e(ex.toString());
        logger.e(trace.toString());
      }
    });
    return res;
  }

  static Post getPost(String html) {
    var document = parse(html);
    var postElement = document.querySelector('.post-item')!;

    Post post = Post();
    post.id = int.parse(postElement.attributes['id']!.replaceAll('post-', ''));
    post.votes = int.parse(postElement.querySelector('.post_points')!.innerHtml);
    post.time = postElement.querySelector('.fixedTime')!.text.trim();
    post.commentsNumber = '-';
    post.title = document.querySelector('.title--main')!.text.trim();
    post.content = document.querySelector('.post_content')!.innerHtml;

    User user = User();
    user.slug = postElement.querySelector('.meta__user .lightBoxUserLnk')!.attributes['slug']!;
    user.fullName = postElement.querySelector('.meta__user')!.text.trim();
    user.avatar = postElement.querySelector('.meta__user .lightBoxUserLnk img')!.attributes['src']!;
    post.user = user;

    Community community = Community();
    community.slug = postElement.querySelector('.meta__details li .lightBoxUserLnk')!.attributes['slug']!;
    community.slug = postElement.querySelector('.meta__details li .lightBoxUserLnk')!.text.trim();
    post.community = community;

    post.comments = getPostComments(post, html, 0);

    return post;
  }

  static List<Comment> getPostComments(Post post, String html, int level) {
    var document = parse(html);

    List<Comment> res = [];
    document.querySelectorAll('.comment-item.lvl-' + level.toString()).forEach((postElement) {
      try {
        Comment comment = Comment();
        comment.level = level;
        comment.id = int.parse(postElement.attributes['id']!.replaceAll('comment-', ''));
        comment.postId = post.id;
        comment.votes = int.parse(postElement.querySelector('.commentMsg .post_points')!.innerHtml);
        comment.time = postElement.querySelector('.commentMsg .fixedTime')!.text.trim();
        comment.content = postElement.querySelector('.commentMsg .commentContent')!.innerHtml;

        User user = User();
        if (postElement.querySelector('.commentMsg .meta__user .lightBoxUserLnk') == null) {
          user.slug = 'عبد-الحميد';
          user.fullName = 'مجهول';
          user.avatar = 'https://avatars.hsoubcdn.com/default?s=128';
        } else {
          user.slug = postElement.querySelector('.commentMsg .meta__user .lightBoxUserLnk')!.attributes['slug']!;
          user.fullName = postElement.querySelector('.commentMsg .meta__user')!.text.trim();
          user.avatar = postElement.querySelector('.commentMsg .meta__user .lightBoxUserLnk img')!.attributes['src']!;
        }
        comment.user = user;

        postElement.querySelectorAll('.comment-item.lvl-' + (level + 1).toString()).forEach((commentElement) {
          comment.comments = getPostComments(post, commentElement.outerHtml, level + 1);
        });

        res.add(comment);
      } catch (ex, trace) {
        // Silence is Golden
      }
    });

    return res;
  }
}
