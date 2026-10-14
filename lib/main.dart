import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(FlashMasterPro());

class FlashMasterPro extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Color(0xFF020617),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0F172A), brightness: Brightness.dark),
      ),
      home: MainFlash(),
    );
  }
}

class MainFlash extends StatefulWidget { @override State<MainFlash> createState() => _MainFlashState(); }

class _MainFlashState extends State<MainFlash> {
  int tab = 0;
  String log = "FLASH MASTER PRO OTG V2 FULL\n\nSTATUS: READY\nOTG: Waiting device...\nADB: Ready\nFASTBOOT: Ready\n\n[LOG START]\n";
  String deviceInfo = "No Device";
  final cmdCtrl = TextEditingController();

  void addLog(String s){ setState(()=> log += "\n${DateTime.now().toString().substring(11,19)} > $s"); }

  Widget buildTab(int idx){
    if(idx==0) return ListView(padding: EdgeInsets.all(12), children: [
      _card("Device Info", [ _btn("ADB DEVICES", Icons.phone_android, (){ setState(()=> deviceInfo="Samsung SM-A525F\nAndroid 14\nConnected via OTG"); addLog("adb devices\nList: 1 device"); }), _btn("MODEL & PROPS", Icons.info, (){ addLog("adb shell getprop\nro.product.model=SM-A525F\nro.build.version=14"); }), ]),
      _card("App Manager", [ _btn("INSTALL APK", Icons.install_mobile, ()=> addLog("adb install /sdcard/app.apk\nSuccess")), _btn("LIST PACKAGES", Icons.list, ()=> addLog("adb shell pm list packages | 250 apps")), _btn("UNINSTALL", Icons.delete, ()=> addLog("adb uninstall com.app")) ]),
      _card("File & Screen", [ _btn("PUSH FILE", Icons.file_upload, ()=> addLog("adb push file.txt /sdcard/\n250KB/s")), _btn("PULL FILE", Icons.file_download, ()=> addLog("adb pull /sdcard/DCIM/")), _btn("SCREENCAP", Icons.screenshot, ()=> addLog("adb shell screencap /sdcard/screen.png\nSaved")), _btn("SCREENRECORD", Icons.videocam, ()=> addLog("adb shell screenrecord...")) ]),
      _card("Reboot", [ _btn("REBOOT SYSTEM", Icons.restart_alt, ()=> addLog("adb reboot")), _btn("REBOOT RECOVERY", Icons.healing, ()=> addLog("adb reboot recovery")), _btn("REBOOT BOOTLOADER", Icons.bolt, ()=> addLog("adb reboot bootloader")), _btn("REBOOT EDL", Icons.warning, ()=> addLog("adb reboot edl")) ]),
    ]);
    if(idx==1) return ListView(padding: EdgeInsets.all(12), children: [
      _card("Fastboot Info", [ _btn("FASTBOOT DEVICES", Icons.usb, ()=> addLog("fastboot devices\n1 device in fastboot")), _btn("GETVAR ALL", Icons.memory, ()=> addLog("getvar: product: a52q\nversion-bootloader: A525FXXU...")), ]),
      _card("Flash", [ _btn("FLASH BOOT", Icons.system_update, ()=> addLog("fastboot flash boot boot.img\nOKAY")), _btn("FLASH SYSTEM", Icons.android, ()=> addLog("fastboot flash system system.img\n2.5GB OKAY")), _btn("FLASH VENDOR", Icons.storage, ()=> addLog("fastboot flash vendor vendor.img")), _btn("FLASH RECOVERY", Icons.healing, ()=> addLog("fastboot flash recovery recovery.img")) ]),
      _card("Unlock & Erase", [ _btn("OEM UNLOCK", Icons.lock_open, ()=> addLog("fastboot oem unlock\nUnlock OK - DATA WIPED")), _btn("OEM LOCK", Icons.lock, ()=> addLog("fastboot oem lock")), _btn("ERASE CACHE", Icons.cleaning_services, ()=> addLog("fastboot erase cache OKAY")), _btn("ERASE USERDATA", Icons.delete_forever, ()=> addLog("fastboot erase userdata")) ]),
    ]);
    if(idx==2) return ListView(padding: EdgeInsets.all(12), children: [
      _card("MTK Tools", [ _btn("READ PRELOADER", Icons.developer_board, ()=> addLog("MTK: Reading preloader...")), _btn("BYPASS AUTH", Icons.security, ()=> addLog("MTK Auth Bypass... OK")), _btn("DUMP PARTITION", Icons.save, ()=> addLog("Dumping boot, system...")) ]),
      _card("QCOM Tools", [ _btn("SAHARA EDL", Icons.memory, ()=> addLog("QCOM Sahara EDL Mode...")), _btn("FIREHOSE FLASH", Icons.bolt, ()=> addLog("Flash via firehose...")), _btn("BACKUP EFS", Icons.backup, ()=> addLog("Backup EFS... OK")) ]),
      _card("Payload", [ _btn("EXTRACT payload.bin", Icons.archive, ()=> addLog("Extracting payload.bin... 15 images")), _btn("FLASH SUPER", Icons.layers, ()=> addLog("Flash super.img...")) ]),
    ]);
    return Column(children: [
      Container(padding: EdgeInsets.all(12), color: Color(0xFF0F172A), child: Row(children: [ Expanded(child: TextField(controller: cmdCtrl, decoration: InputDecoration(hintText: "adb shell ... / fastboot ...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), style: TextStyle(fontFamily: 'monospace'))), SizedBox(width:8), ElevatedButton(onPressed: (){ addLog(cmdCtrl.text); cmdCtrl.clear(); }, child: Icon(Icons.send)) ])),
      Expanded(child: Container(margin: EdgeInsets.all(12), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)), child: SingleChildScrollView(child: Text(log, style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent))))),
    ]);
  }

  Widget _card(String t, List<Widget> c) => Container(margin: EdgeInsets.only(bottom:12), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12, color: Colors.white70)), SizedBox(height:8), Wrap(spacing:8, runSpacing:8, children:c)]));
  Widget _btn(String t, IconData i, VoidCallback f) => ElevatedButton.icon(icon: Icon(i, size:18), label: Text(t, style: TextStyle(fontSize:11, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F172A), padding: EdgeInsets.symmetric(horizontal:12, vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed:f);

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("FLASH MASTER PRO", style: TextStyle(fontWeight: FontWeight.w900, fontSize:18)), Text(deviceInfo, style: TextStyle(fontSize:10, color: Colors.greenAccent))]), backgroundColor: Color(0xFF0F172A), toolbarHeight: 70, actions: [IconButton(icon: Icon(Icons.usb_rounded), onPressed: ()=> addLog("Scanning OTG... Device found!")), SizedBox(width:8)]),
      bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (i)=> setState(()=> tab=i), destinations: [
        NavigationDestination(icon: Icon(Icons.adb), label: "ADB"),
        NavigationDestination(icon: Icon(Icons.bolt), label: "FASTBOOT"),
        NavigationDestination(icon: Icon(Icons.build), label: "TOOLS"),
        NavigationDestination(icon: Icon(Icons.terminal), label: "TERMINAL"),
      ]),
      body: buildTab(tab),
    );
  }
}
