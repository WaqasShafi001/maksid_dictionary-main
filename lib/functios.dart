import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

/*
 Future<bool> chectConnection()async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  print(connectivityResult);
  if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}
*/

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}

play(String url) async {
  var dio = Dio();

  AudioPlayer player = new AudioPlayer();
  final audioUrl = "https://maksid.com/aud/" + url;

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;

  //String fullPath = tempDir.path + "/boo2.pdf'";
  String fullPath = "$path/$url";
  print('full path is =  $fullPath');

  if (File(fullPath).existsSync()) {
    print('file exists: ' + fullPath);
    print("play the file");
    player.play(fullPath, isLocal: true);
  } else {
    print('file does not exists:');
    try {
      print('enters in try block');
      Response response = await dio.get(
        audioUrl,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      player.play(fullPath, isLocal: true);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }
}
