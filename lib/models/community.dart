import 'base_model.dart';

class Community extends BaseModel {
  int id = 0;
  String slug = '';
  String name = '';
  String description = '';
  String followers = '';
  bool isfollowing = false;
  Community();
}
