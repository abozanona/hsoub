import 'package:hsoub/models/user.dart';

import 'base_model.dart';

class Comment extends BaseModel {
  int id = 0;
  int postId = 0;
  User user = User();
  String time = '';
  String content = '';
  int votes = 0;
  List<Comment> comments = [];
  int level = 0;
}
