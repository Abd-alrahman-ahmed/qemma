import 'package:qemma_mobile/models/action_status_enum.dart';

class ActionResult<T> {
  T? data;
  ActionStatus? status;
  bool isSucceeded;

  ActionResult({
    this.data,
    this.status,
    required this.isSucceeded,
  });
}
