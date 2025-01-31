import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vikunja_app/components/date_extension.dart';

import 'package:vikunja_app/models/label.dart';
import 'package:vikunja_app/models/user.dart';
import 'package:vikunja_app/models/taskAttachment.dart';
import 'package:vikunja_app/utils/checkboxes_in_text.dart';

@JsonSerializable()
class Task {
  final int id, parentTaskId, priority, listId, bucketId;
  final DateTime created, updated, dueDate, startDate, endDate;
  final List<DateTime> reminderDates;
  final String title, description, identifier;
  final bool done;
  final Color color;
  final double kanbanPosition;
  final User createdBy;
  final Duration repeatAfter;
  final List<Task> subtasks;
  final List<Label> labels;
  final List<TaskAttachment> attachments;
  // TODO: add position(?)

  // // TODO: use `late final` once upgraded to current dart version
  CheckboxStatistics _checkboxStatistics;

  bool loading = false;

  Task({
    @required this.id,
    this.title,
    this.description,
    this.identifier,
    this.done = false,
    this.reminderDates,
    this.dueDate,
    this.startDate,
    this.endDate,
    this.parentTaskId,
    this.priority,
    this.repeatAfter,
    this.color,
    this.kanbanPosition,
    this.subtasks,
    this.labels,
    this.attachments,
    this.created,
    this.updated,
    this.createdBy,
    this.listId,
    this.bucketId,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        identifier = json['identifier'],
        done = json['done'],
        reminderDates = (json['reminder_dates'] as List<dynamic>)
            ?.map((ts) => DateTime.parse(ts))
            ?.cast<DateTime>()
            ?.toList(),
        dueDate = DateTime.parse(json['due_date']),
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.parse(json['end_date']),
        parentTaskId = json['parent_task_id'],
        priority = json['priority'],
        repeatAfter = Duration(seconds: json['repeat_after']),
        color = json['hex_color'] == ''
            ? null
            : new Color(int.parse(json['hex_color'], radix: 16) + 0xFF000000),
        kanbanPosition = json['kanban_position'] is int
            ? json['kanban_position'].toDouble()
            : json['kanban_position'],
        labels = (json['labels'] as List<dynamic>)
            ?.map((label) => Label.fromJson(label))
            ?.cast<Label>()
            ?.toList(),
        subtasks = (json['subtasks'] as List<dynamic>)
            ?.map((subtask) => Task.fromJson(subtask))
            ?.cast<Task>()
            ?.toList(),
        attachments = (json['attachments'] as List<dynamic>)
            ?.map((attachment) => TaskAttachment.fromJSON(attachment))
            ?.cast<TaskAttachment>()
            ?.toList(),
        updated = DateTime.parse(json['updated']),
        created = DateTime.parse(json['created']),
        listId = json['list_id'],
        bucketId = json['bucket_id'],
        createdBy = json['created_by'] == null
            ? null
            : User.fromJson(json['created_by']);

  toJSON() => {
        'id': id,
        'title': title,
        'description': description,
        'identifier': identifier,
        'done': done ?? false,
        'reminder_dates':
            reminderDates?.map((date) => date?.toUtc()?.toIso8601String())?.toList(),
        'due_date': dueDate?.toUtc()?.toIso8601String(),
        'start_date': startDate?.toUtc()?.toIso8601String(),
        'end_date': endDate?.toUtc()?.toIso8601String(),
        'priority': priority,
        'repeat_after': repeatAfter?.inSeconds,
        'hex_color': color?.value?.toRadixString(16)?.padLeft(8, '0')?.substring(2),
        'kanban_position': kanbanPosition,
        'labels': labels?.map((label) => label.toJSON())?.toList(),
        'subtasks': subtasks?.map((subtask) => subtask.toJSON())?.toList(),
        'attachments': attachments?.map((attachment) => attachment.toJSON())?.toList(),
        'bucket_id': bucketId,
        'created_by': createdBy?.toJSON(),
        'updated': updated?.toUtc()?.toIso8601String(),
        'created': created?.toUtc()?.toIso8601String(),
      };

  Color get textColor => color != null
      ? color.computeLuminance() > 0.5 ? Colors.black : Colors.white
      : null;

  CheckboxStatistics get checkboxStatistics {
    if (_checkboxStatistics != null)
      return _checkboxStatistics;
    if (description.isEmpty)
      return null;

    _checkboxStatistics = getCheckboxStatistics(description);
    return _checkboxStatistics;
  }

  bool get hasCheckboxes {
    final checkboxStatistics = this.checkboxStatistics;
    if (checkboxStatistics != null && checkboxStatistics.total != 0)
      return true;
    else
      return false;
  }

  bool get hasDueDate => dueDate.year != 1;

  Task copyWith({
    int id, int parentTaskId, int priority, int listId, int bucketId,
    DateTime created, DateTime updated, DateTime dueDate, DateTime startDate, DateTime endDate,
    List<DateTime> reminderDates,
    String title, String description, String identifier,
    bool done,
    Color color,
    bool resetColor,
    double kanbanPosition,
    User createdBy,
    Duration repeatAfter,
    List<Task> subtasks,
    List<Label> labels,
    List<TaskAttachment> attachments,
  }) {
    return Task(
      id: id ?? this.id,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      priority: priority ?? this.priority,
      listId: listId ?? this.listId,
      bucketId: bucketId ?? this.bucketId,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminderDates: reminderDates ?? this.reminderDates,
      title: title ?? this.title,
      description: description ?? this.description,
      identifier: identifier ?? this.identifier,
      done: done ?? this.done,
      color: (resetColor ?? false) ? null : (color ?? this.color),
      kanbanPosition: kanbanPosition ?? this.kanbanPosition,
      createdBy: createdBy ?? this.createdBy,
      repeatAfter: repeatAfter ?? this.repeatAfter,
      subtasks: subtasks ?? this.subtasks,
      labels: labels ?? this.labels,
      attachments: attachments ?? this.attachments,
    );
  }
}
