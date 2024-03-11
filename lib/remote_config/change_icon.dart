import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

class ChangeIcon extends StatefulWidget {
  const ChangeIcon({super.key});

  @override
  State<ChangeIcon> createState() => _ChangeIconState();
}

class _ChangeIconState extends State<ChangeIcon> {
  int iconIndex = 0;
  List iconName = <String>['icon1', 'icon2', 'icon3'];
  List imageFiles = <String>['assets/logo.png', 'assets/images/icons/linkedin.png', 'assets/images/icons/facebook.png'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        backgroundColor: Colors.white,
        title: Text("Change AppIcon",style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconTile(0, 'Firebase'),
              buildIconTile(1, 'LinkedIn'),
              buildIconTile(2, 'Facebook'),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () => changeAppIcon(), child: Text('Set as app icon')
              ),
            ],
          )),
    );
  }


  Widget buildIconTile(int index, String themeTxt) => Padding(
    padding: EdgeInsets.all(10),
    child: GestureDetector(
      onTap: () => setState(() => iconIndex = index),
      child: ListTile(
          contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          leading: Image.asset(
            imageFiles[index],
            width: 45,
            height: 45,
          ),
          title: Text(themeTxt, style: const TextStyle(fontSize: 25)),
          trailing: iconIndex == index
              ? const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 30,
          )
              : Icon(
            Icons.circle_outlined,
            color: Colors.grey.withOpacity(0.5),
            size: 30,
          ),
      ),
    ),
  );

  changeAppIcon() async {
    try {
      if (await FlutterDynamicIcon.supportsAlternateIcons) {
        await FlutterDynamicIcon.setAlternateIconName(iconName[iconIndex]);
        debugPrint("App icon change successful");
        return;
      }
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }
    debugPrint("Failed to change app icon ");
  }

}
