import 'package:education_app/layout/cubit/main_cubit.dart';
import 'package:education_app/screens/filter_screen/filter_screen.dart';
import 'package:education_app/screens/student_screen/widgets/level_drop_down.dart';
import 'package:education_app/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/department_drop_down.dart';
import 'widgets/student_item.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FilterdStudentScreen())),
                  icon: Icon(Icons.filter_alt_rounded,color: AppColors.darkPrimary),),
              ),
              /*      Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DropDownLevel(cubit: MainCubit.get(context)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DropDownDepartment(cubit: MainCubit.get(context)),
                ),
                const SizedBox(height: 10),*/
              Expanded(
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return StudentItem(
                        studentModel:
                        MainCubit
                            .get(context)
                            .studentsList[index],
                        cubit: MainCubit.get(context),
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                    itemCount: MainCubit
                        .get(context)
                        .studentsList
                        .length),
              ),
            ],
          ),
        );
      },
    );
  }
}
