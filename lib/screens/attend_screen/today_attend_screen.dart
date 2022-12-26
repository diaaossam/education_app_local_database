import 'package:education_app/layout/cubit/main_cubit.dart';
import 'package:education_app/screens/attend_screen/widget/attend_design.dart';
import 'package:education_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodayAttendScreen extends StatelessWidget {
  const TodayAttendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "${DateFormat.yMMMMd().format(DateTime.now())}",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * .15,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Text(
                        "رقم الهوية",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      )),
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width * .2,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Text("الإســـــــــم",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * .15,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Text(
                        "الشعبة",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width * .2,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: const Text(
                        "الحضور ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * .15,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Text(
                            "${MainCubit.get(context).attendList[index].userId}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          )),
                      Expanded(
                        child: Container(
                            width: MediaQuery.of(context).size.width * .2,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 1)),
                            child: Text(
                              "${MainCubit.get(context).attendList[index].name}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * .15,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Text(
                            "${MainCubit.get(context).attendList[index].department}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * .2,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Text(
                            "${MainCubit.get(context).attendList[index].isAttend == 1 ? "حضر" : "لم يحضر"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          )),
                    ],
                  ),
                  itemCount: MainCubit.get(context).attendList.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
