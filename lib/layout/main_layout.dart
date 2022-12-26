import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:education_app/layout/cubit/main_cubit.dart';
import 'package:education_app/screens/search_screen/search_screen.dart';
import 'package:education_app/widget/alert_dialog_builder.dart';
import 'package:education_app/widget/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/app_colors.dart';

/*class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return DefaultTabController(
          length: cubit.studentLevels.length,
          child: Scaffold(
            body: BackgroundWidget(cubit.screens[cubit.currentIndex]),
            appBar: AppBar(
              actions: [
                cubit.currentIndex == 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: IconButton(
                            onPressed: () => showAddDialog(context, cubit),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            )),
                      )
                    : SizedBox(),
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen())),
                    icon: Icon(Icons.search)),
              ],
              bottom: cubit.currentIndex == 1
                  ? TabBar(
                      isScrollable: true,
                      indicatorColor: AppColors.darkPrimary,
                      tabs: cubit.tabs,
                    )
                  : null,
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.darkPrimary,
              title: Text(cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Cairo",
                    fontSize: 23,
                  )),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {

                cubit.insertAttendToDataBase(userId: 1, name: "diaa", department: 'd');
                //await LocalAuthApi.authenticate();
              },
            ),
            bottomNavigationBar: CurvedNavigationBar(
              items: cubit.bottomNaviItems,
              onTap: (index) => cubit.changeBottomNav(index),
              index: cubit.currentIndex,
              backgroundColor: AppColors.background,
              color: AppColors.darkPrimary,
            ),
          ),
        );
      },
    );
  }

  Future<void> showAddDialog(context, MainCubit cubit) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialogBuilder(
          cubit: cubit,
        );
      },
    );
  }
}*/


class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return Scaffold(
          body: BackgroundWidget(cubit.screens[cubit.currentIndex]),
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen())),
                  icon: Icon(Icons.search)),
            ],
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.darkPrimary,
            title: Text(cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Cairo",
                  fontSize: 23,
                )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              switch(cubit.currentIndex){
                case 0:
                  showAddDialog(context, cubit);
                  break;
                case 1:
                  cubit.insertAttendToDataBase(userId: 1, name: "diaa", department: 'd');
                  break;
                case 2:
                //  cubit.pickFile();
                  break;
              }
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            items: cubit.bottomNaviItems,
            onTap: (index) => cubit.changeBottomNav(index),
            index: cubit.currentIndex,
            backgroundColor: AppColors.background,
            color: AppColors.darkPrimary,
          ),
        );
      },
    );
  }

  Future<void> showAddDialog(context, MainCubit cubit) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialogBuilder(
          cubit: cubit,
        );
      },
    );
  }
}