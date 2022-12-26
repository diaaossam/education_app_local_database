import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:education_app/models/attend_model.dart';
import 'package:education_app/screens/attend_screen/today_attend_screen.dart';
import 'package:education_app/screens/report_screen/report_screen.dart';
import 'package:education_app/screens/settings_screen/settings_screen.dart';
import 'package:education_app/screens/student_screen/student_screen.dart';
import 'package:education_app/shared/app_strings.dart';
import 'package:education_app/shared/constant.dart';
import 'package:education_app/shared/local_auth_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/student_model.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavIndexState());
  }

  List<String> titles = [
    (AppString.students),
    (AppString.attend),
    (AppString.report),
    (AppString.settings),
  ];
  List<Widget> screens = [
    const StudentScreen(),
    const TodayAttendScreen(),
    ReportScreen(),
    const SettingsScreen(),
  ];

  List<Widget> bottomNaviItems = const [
    Icon(Icons.person_4_outlined, size: 30, color: Colors.white),
    Icon(Icons.list, size: 30, color: Colors.white),
    Icon(CupertinoIcons.rectangle_paperclip, size: 30, color: Colors.white),
    Icon(CupertinoIcons.settings, size: 30, color: Colors.white),
  ];

  //////////////////// Auth /////////////////////////

  Future<bool> authWithFinger() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    return isAuthenticated;
  }

  Future<void> startNfc() async {
    await _createDatabase();
    if (await authWithFinger == true) {
      if (true) {
        // Start Session
        /*NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          // Do something with an NfcTag instance.
        },
      );*/
      }
      // Check availability
      bool isAvailable = await NfcManager.instance.isAvailable();
    } else {
      emit(NfcNotFoundState());
    }
  }

  ///////// StudentDatabase/////////////

  Database? database;

  Future<void> _createDatabase() async {
    await openDatabase(AppString.databaseName,
        version: AppString.databaseVersion,
        onCreate: (database, version) async {
      await database.execute(AppString.createDatabaseQuery);
      await database.execute(AppString.createDatabaseAttend);
      await database.execute(AppString.createDatabasePdf);
    }, onOpen: (database) {
      getAllStudents(database);
      getAllAttends(database);
      print("Data base Opened");
    }).then((value) {
      this.database = value;
      emit(CreateDatabaseState());
    });
  }

  Future<String> converImage({required File image}) async {
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Uint8List converStringtoImage({required String image}) {
    Uint8List _bytesImage = Base64Decoder().convert(image);
    return _bytesImage;
  }

  Future<void> insertStudentToDataBase(
      {required String name,
      required String email,
      File? image,
      required bool isWithImage,
      required String level,
      required String department}) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO ${AppString.tableName} (${AppString.name},${AppString.email} , ${AppString.department}, ${AppString.level}, ${AppString.image} ) VALUES("$name","$email","$department","$level","${isWithImage ? await converImage(image: image!) : AppString.defaultValue}")')
          .then((value) {
        getAllStudents(database);
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  List<StudentModel> studentsList = [];

  void getAllStudents(database) {
    emit(GetAllStudentsLoading());
    database.rawQuery('SELECT * FROM ${AppString.tableName}').then((value) {
      studentsList.clear();
      List list = value as List;
      list.forEach((element) {
        StudentModel studentModel = StudentModel(
            id: element['id'],
            name: element['name'],
            deparment: element['department'],
            email: element['email'],
            level: element['level'],
            image: element['image']);
        studentsList.add(studentModel);
      });
      emit(GetAllStudentsSuccess());
    });
  }

  void deleteStudent({required int id}) async {
    await database!.rawDelete(
        'DELETE FROM ${AppString.tableName} WHERE id = ?', [id]).then((value) {
      getAllStudents(database);
      emit(DeleteDatabaseState());
    });
  }

  Future<int> updateStudent({required StudentModel model}) async {
    var res = await database!.update(AppString.tableName, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
    return res;
  }

  ////////////////////////// AttendScreen ///////////////////////
  void insertAttendToDataBase({
    required int userId,
    required String name,
    required String department,
  }) async {
    var contain = attendList.where((element) => element.userId == userId);
    if (contain.isEmpty) {
      await database!.transaction((txn) async {
        txn
            .rawInsert(
                'INSERT INTO ${AppString.attendTable} (${AppString.userId}, ${AppString.name}, ${AppString.date}, ${AppString.time}, ${AppString.isAttend}, ${AppString.department} ) VALUES(${1},"${name}","${formatDate()}","${formatTime()}",${1},"${department}")')
            .then((value) async {
          getAllAttends(database);
        }).catchError((error) {});
      });
    }
  }

  List<AttendModel> attendList = [];

  Future<void> getAllAttends(database) async {
    emit(GetAllStudentsLoading());
    database.rawQuery('SELECT * FROM ${AppString.attendTable}').then((value) {
      attendList.clear();
      value.forEach((element) {
        int userId = element["userId"];
        String name = element["name"];
        String date = element["date"];
        String time = element["time"];
        int isAttend = element["isAttend"];
        String department = element['department'];
        AttendModel model = AttendModel(
            name: name,
            userId: userId,
            date: date,
            time: time,
            isAttend: isAttend,
            department: department);
        attendList.add(model);
      });
      GetAllAttendsSuccess();
    });
  }

  /////////////////////////// Tabs //////////////////////////////

  List<Widget> tabs = const [
    Tab(
      text: AppString.first,
    ),
    Tab(
      text: AppString.second,
    ),
    Tab(
      text: AppString.third,
    ),
    Tab(
      text: AppString.forth,
    ),
    Tab(
      text: AppString.fifth,
    ),
    Tab(
      text: AppString.sixth,
    ),
  ];

  ///////////////////////// Report Screen ///////////////////////

  List<AttendModel> attendModelByDateList = [];

  void getReport({required String date}) {
    database!.query(AppString.attendTable,
        where: "date LIKE ?", whereArgs: ['%$date']).then((value) {
      attendModelByDateList.clear();
      value.forEach((element) {
        AttendModel attendModel = AttendModel(
            userId: element['userId'] as int,
            name: element['name'] as String,
            date: element['date'] as String,
            time: element['time'] as String,
            isAttend: element['isAttend'] as int,
            department: element['department'] as String);
        attendModelByDateList.add(attendModel);
      });
      emit(GetALlReportByDateState());
    });
  }

  ///////////////////// Search Screen //////////////////////

  List<StudentModel> searchList = [];

  void searchAllStudents({required String name}) {
    database!.query(AppString.tableName,
        where: "name LIKE ?", whereArgs: ['%$name']).then((value) {
      searchList.clear();
      value.forEach((element) {
        StudentModel studentModel = StudentModel(
            id: element['id'] as int,
            name: element['name'] as String,
            deparment: element['department'] as String,
            email: element['email'] as String,
            level: element['level'] as String,
            image: element['image'] as String);
        searchList.add(studentModel);
      });
      emit(GetAllSearchSuccess());
    });
  }

  ////////////////////////////Filter Screen//////////////////////////

  List<String> studentLevels = [
    AppString.first,
    AppString.second,
    AppString.third,
    AppString.forth,
  ];

  List<String> studentDepartments = [];

  String? studentLevel;

  void chooseStudentLevel({required String level}) {
    if (department == null) {
      studentLevel = level;
      addSecond();
      emit(ChooseStudentLevelState());
    } else {
      department = null;
      studentLevel = level;
      addSecond();
      emit(ChooseStudentLevelState());
    }
  }

  String? department;

  void addSecond() {
    studentDepartments.clear();
    if (studentLevel == AppString.first) {
      studentDepartments.add(AppString.depart1);
      studentDepartments.add(AppString.depart12);
    } else if (studentLevel == AppString.second) {
      studentDepartments.add(AppString.depart2);
      studentDepartments.add(AppString.depart22);
    } else if (studentLevel == AppString.third) {
      studentDepartments.add(AppString.depart3);
      studentDepartments.add(AppString.depart33);
    } else if (studentLevel == AppString.forth) {
      studentDepartments.add(AppString.depart4);
      studentDepartments.add(AppString.depart44);
    }
    emit(ChooseState());
  }

  void chooseStudentDepartment({required String level}) {
    this.department = level;
    filterStudent();
    emit(ChooseStudentDepartmentState());
  }

  List<StudentModel> filterdList = [];

  void filterStudent() async {
    List result = await database!.rawQuery(
        'SELECT * FROM ${AppString.tableName} WHERE level=? and department=?',
        ['${studentLevel}', '$department']);

    filterdList =
        result.map<StudentModel>((e) => StudentModel.fromJson(e)).toList();
    emit(FilterState());
  }

  /////////////////////////////// External ////////////////////////

  File? updatedStudentImage;

  Future<void> chooseStudentImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      updatedStudentImage = File(image.path);
      emit(ChooseUpdatedStudentState());
    }
  }
}
