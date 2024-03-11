import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MapDataToWidget{
  List<Widget> serverWidget = [];

  mapWidgets(serverUI){
    for(var element in jsonDecode(serverUI)){
      String type = element['type'];
      serverWidget.add(toWidget(element, type));
    }
    return serverWidget;
  }
  Widget toWidget(dynamic element, String type) {
    switch (type) {
      case 'FlutterLogo':
        return FlutterLogo(
          size: (element['size'] as int).toDouble(),
        );
      case 'Container':
        return Container(
          width: (element['width'] as int).toDouble(),
          height: (element['height'] as int).toDouble(),
          decoration: BoxDecoration(
            color: HexColor(element['color']),
            borderRadius: BorderRadius.circular(
              (element['attribute']['decoration']['borderRadius'] as int).toDouble(),
            ),
            border: Border.all(
              color: HexColor(element['attribute']['decoration']['borderColor']),
              width: (element['attribute']['decoration']['borderWidth'] as int).toDouble(),
            ),
            boxShadow: element['attribute']['decoration']['boxShadow'] != null
                ? [
              BoxShadow(
                color: HexColor(element['attribute']['decoration']['boxShadow']['color']),
                spreadRadius: (element['attribute']['decoration']['boxShadow']['spreadRadius'] as int).toDouble(),
                blurRadius: (element['attribute']['decoration']['boxShadow']['blurRadius'] as int).toDouble(),
                offset: Offset(
                  (element['attribute']['decoration']['boxShadow']['offsetX'] as int).toDouble(),
                  (element['attribute']['decoration']['boxShadow']['offsetY'] as int).toDouble(),
                ),
              ),
            ]
                : null,
          ),
          child: toWidget(element['attribute'], element['attribute']['types']),
        );
      case 'Text':
        return Text(
          element['txtData'],
          style: TextStyle(
            fontSize: (element['style']['fontSize'] as int).toDouble(),
            color: HexColor(element['style']['color']),
          ),
        );
      case 'Column':
        List<Widget> columnChildren = [];
        for (var child in element['children']) {
          columnChildren.add(toWidget(child, child['type']));
        }
        return Column(
          children: columnChildren,
        );
      case 'Center':
        return Center(
          child: toWidget(element['child'], element['child']['type']),
        );
      default:
        return const Text('Error Fetching Data');
    }
  }
}