import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vikunja_app/global.dart';
import 'package:vikunja_app/models/list.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();

}

class SettingsPageState extends State<SettingsPage> {
  List<TaskList> taskListList;
  int defaultList;
  bool ignoreCertificates;

  @override
  Widget build(BuildContext context) {
    if(taskListList == null)
      VikunjaGlobal.of(context).listService.getAll().then((value) => setState(() => taskListList = value));
    if(defaultList == null)
      VikunjaGlobal.of(context).listService.getDefaultList().then((value) => setState(() => defaultList = value == null ? null : int.tryParse(value)));

    if(ignoreCertificates == null)
      VikunjaGlobal.of(context).settingsManager.getIgnoreCertificates().then((value) => setState(() => ignoreCertificates = value == "1" ? true:false));

    return new Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Column(
        children: [
          taskListList != null ?
          ListTile(
            title: Text("Default List"),
            trailing: DropdownButton(
              items: [DropdownMenuItem(child: Text("None"), value: null,), ...taskListList.map((e) => DropdownMenuItem(child: Text(e.title), value: e.id)).toList()],
              value: defaultList,
              onChanged: (value){
                setState(() => defaultList = value);
                VikunjaGlobal.of(context).listService.setDefaultList(value);
                },
            ),) : ListTile(title: Text("..."),),
          ignoreCertificates != null ?
              CheckboxListTile(title: Text("Ignore Certificates"), value: ignoreCertificates, onChanged: (value) {
                setState(() => ignoreCertificates = value);
                VikunjaGlobal.of(context).settingsManager.setIgnoreCertificates(value);
                VikunjaGlobal.of(context).client.ignoreCertificates = value;
              }) : ListTile(title: Text("..."))
        ],
      ),
    );
  }

}