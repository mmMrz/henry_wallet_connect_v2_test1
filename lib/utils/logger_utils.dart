// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:date_formatter/date_formatter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> createDirectory() async {
  return null;
  // final Directory directory = await getApplicationDocumentsDirectory();

  final Directory? directory = await getExternalStorageDirectory();
  // final File file = File('${directory.absolute.path}/logger');
  if (directory == null) return null;
  var file = Directory("${directory.path}/lyd");
  Logger().d("准备写入文件:${file.absolute.path}}");

  // var file = Directory(directory.path + "/" + "lyd");
  try {
    bool exist = await file.exists();
    if (exist == false) {
      await file.create();
    }
  } catch (e) {
    Logger().d("createDirectory error");
  }

  return file.path;
}

class LoggerManager {
  //私有构造函数
  LoggerManager._internal() {
    deleteLogsOfBefore7Day();
    initLogger();
  }

  //保存单例
  static final LoggerManager _singleton = LoggerManager._internal();

  //工厂构造函数
  factory LoggerManager() => _singleton;

  late Logger logger;

  // log初始化设置
  Future<void> initLogger() async {
    //暂时不需要输出日志到文件/No need to output logs to files for the time being
    // FileOutput fileOutPut = FileOutput();
    ConsoleOutput consoleOutput = ConsoleOutput();
    List<LogOutput> multiOutput = [consoleOutput];
    //设置日志输出等级/add Logger output level
    Logger.level = Level.verbose;
    logger = Logger(
      // filter: DevelopmentFilter(),
      filter: MyFilter(),
      // Use the default LogFilter (-> only log in debug mode)
      // printer: SimplePrinter(
      //   colors: true,
      //   printTime: true,
      // ),
      printer: HybridPrinter(
        PrettyPrinter(
          noBoxingByDefault: false,
          methodCount: 2,
          // number of method calls to be displayed
          errorMethodCount: 8,
          // number of method calls if stacktrace is provided
          lineLength: 120,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: false,
          // Print an emoji for each log message
          printTime: true, // Should each log print contain a timestamp
        ),
        debug: SimplePrinter(),
      ),

      // printer: PrefixPrinter(PrettyPrinter(
      //   noBoxingByDefault: true,
      //   methodCount: 2,
      //   // number of method calls to be displayed
      //   errorMethodCount: 8,
      //   // number of method calls if stacktrace is provided
      //   lineLength: 120,
      //   // width of the output
      //   colors: true,
      //   // Colorful log messages
      //   printEmojis: false,
      //   // Print an emoji for each log message
      //   printTime: true, // Should each log print contain a timestamp
      // )),

      // printer: PrettyPrinter(
      //   noBoxingByDefault: true,
      //   methodCount: 2,
      //   // number of method calls to be displayed
      //   errorMethodCount: 8,
      //   // number of method calls if stacktrace is provided
      //   lineLength: 120,
      //   // width of the output
      //   colors: true,
      //   // Colorful log messages
      //   printEmojis: false,
      //   // Print an emoji for each log message
      //   printTime: true, // Should each log print contain a timestamp
      // ),
      // Use the PrettyPrinter to format and print log
      output: MultiOutput(
        multiOutput,
      ), // Use the default LogOutput (-> send everything to console)
    );
  }

  // Debug
  void d(dynamic message) {
    logger.d("WCLOG-->$message");
  }

  // verbose
  void v(dynamic message) {
    logger.v("WCLOG-->$message");
  }

  // info
  void i(dynamic message) {
    logger.i("WCLOG-->$message");
  }

  // warning
  void w(dynamic message) {
    logger.w("WCLOG-->$message");
  }

  // error
  void e(dynamic message) {
    logger.e("WCLOG-->$message");
  }

  // 每次启动只保留7天内的日志，删除7天前的日志
  Future<void> deleteLogsOfBefore7Day() async {
    final String? fileDir = await createDirectory();
    if (fileDir == null) return;
    // 获取目录的所有文件
    var dir = Directory(fileDir);
    Stream<FileSystemEntity> file = dir.list();
    await for (FileSystemEntity x in file) {
      // 获取文件的的名称
      List<String> paths = x.path.split('/');
      if (paths.isNotEmpty) {
        String logName = paths.last.replaceAll('.log', '');
        final logDate = DateTime.tryParse(logName);
        final currentDate = DateTime.now();
        //比较相差的天数
        if (logDate != null) {
          final difference = currentDate.difference(logDate).inDays;
          logger.d("deleteLogsOfBefore7Day logDate:$logDate, currentDate:$currentDate, difference:$difference");
          if (difference > 7) {
            var file = File(x.path);
            // 删除文件
            file.delete();
          }
        }
      }
    }
  }
}

/// Writes the log output to a file.
class FileOutput extends LogOutput {
  final bool overrideExisting;
  final Encoding encoding;
  late IOSink _sink;

  late File file;
  late String _currentDate;

  FileOutput({
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  Future<void> getDirectoryForLogRecord() async {
    String currentDate = getCurrentDay();
    if (currentDate != _currentDate) {
      final String? fileDir = await createDirectory();
      if (fileDir == null) return;
      file = File('$fileDir/$currentDate.log');

      _sink = file.openWrite(
        mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
        encoding: encoding,
      );

      _currentDate = currentDate;
    }
  }

  String getCurrentDay() {
    String currentDate = DateFormatter.formatDateTime(dateTime: DateTime.now(), outputFormat: "yyyyMMdd");
    return currentDate;
  }

  @override
  void init() {
    directoryLogRecord(onCallback: () {});
  }

  void directoryLogRecord({required Function onCallback}) {
    getDirectoryForLogRecord().whenComplete(() {
      onCallback();
    });
  }

  @override
  void output(OutputEvent event) {
    directoryLogRecord(onCallback: () {
      if (event.level.index >= Logger.level.index) {
        _sink.writeAll(event.lines, '\n');
      }
      // if (Level.info == event.level || Level.warning == event.level || Level.error == event.level) {
      //   _sink?.writeAll(event.lines, '\n');
      // }
    });
  }

  @override
  void destroy() async {
    await _sink.flush();
    await _sink.close();
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level.index >= Logger.level.index) {
      return true;
    }
    return false;
  }
}

LoggerManager log = LoggerManager();
