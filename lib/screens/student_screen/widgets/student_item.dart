import 'package:education_app/layout/cubit/main_cubit.dart';
import 'package:education_app/models/student_model.dart';
import 'package:education_app/screens/update_screen/update_screen.dart';
import 'package:education_app/shared/app_colors.dart';
import 'package:education_app/shared/app_strings.dart';
import 'package:flutter/material.dart';

class StudentItem extends StatelessWidget {
  final StudentModel studentModel;
  final MainCubit cubit;

  const StudentItem({Key? key, required this.studentModel, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateScreen(studentModel: studentModel))),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (dir) {
            cubit.deleteStudent(id: studentModel.id ?? 1);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: setUpColor(studentModel.level),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  backgroundImage: studentModel.image == AppString.defaultValue
                      ? AssetImage("assets/images/user.png")
                      : MemoryImage(cubit.converStringtoImage(image: studentModel.image ?? "")) as ImageProvider,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            "إسم الطالـــب :",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Cairo",
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "${studentModel.name}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Cairo",
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            "البريــــــــــــــد :",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Cairo",
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "${studentModel.email}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Cairo",
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Text(
                            "المرحلة التعليمية :",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Cairo",
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "${studentModel.level}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Cairo",
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Text(
                            "القســـــــــــم :",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Cairo",
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "${studentModel.deparment}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Cairo",
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color setUpColor(String? level) {
    if (level == AppString.first) {
      return AppColors.first;
    } else if (level == AppString.second) {
      return AppColors.second;
    } else if (level == AppString.third) {
      return AppColors.third;
    } else if (level == AppString.forth) {
      return AppColors.forth;
    } else if (level == AppString.fifth) {
      return AppColors.fifth;
    } else if (level == AppString.sixth) {
      return AppColors.sixth;
    } else {
      return Colors.white;
    }
  }
}
