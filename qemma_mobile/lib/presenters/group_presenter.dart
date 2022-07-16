import 'package:qemma_mobile/helpers/app_firestore.dart';
import 'package:qemma_mobile/models/group_model.dart';

class GroupPresenter {
  Future<List<Group>?> getGroups(bool Function(Group g) test) async {
    var groups = await FireStore.getAll<Group>(
        FirestoreCollections.group, (g) => Group.fromJson(g), test);
    return groups;
  }

  Future<bool> updateGroup(Group group) async => await FireStore.update(
      FirestoreCollections.group, group.id, group.toJson());
}
