import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vikunja_app/components/BucketTaskCard.dart';
import 'package:vikunja_app/models/bucket.dart';
import 'package:vikunja_app/models/task.dart';
import 'package:vikunja_app/stores/list_store.dart';

class SliverBucketList extends StatelessWidget {
  final Bucket bucket;
  final DragUpdateCallback onTaskDragUpdate;

  const SliverBucketList({
    Key key,
    @required this.bucket,
    @required this.onTaskDragUpdate,
  }) : assert(bucket != null),
       assert(onTaskDragUpdate != null),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (bucket.tasks == null) return null;
        return index >= bucket.tasks.length ? null : BucketTaskCard(
          key: ObjectKey(bucket.tasks[index]),
          task: bucket.tasks[index],
          index: index,
          onDragUpdate: onTaskDragUpdate,
          onAccept: (task, index) {
            _moveTaskToBucket(context, task, index);
          },
        );
      }),
    );
  }

  Future<void> _moveTaskToBucket(BuildContext context, Task task, int index) {
    return Provider.of<ListProvider>(context, listen: false).moveTaskToBucket(
      context: context,
      task: task,
      newBucketId: bucket.id,
      index: index,
    ).then((_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${task.title} was moved to ${bucket.title} successfully!'),
    )));
  }
}
