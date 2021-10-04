import 'package:hsoub/models/comment.dart';
import 'package:hsoub/models/community.dart';
import 'package:hsoub/models/user.dart';

import 'base_model.dart';

class Post extends BaseModel {
  int id = 0;
  String title = '';
  User user = User();
  Community community = Community();
  String commentsNumber = '';
  String time = '';
  String content = '';
  int votes = 0;
  List<Comment> comments = [];
}
