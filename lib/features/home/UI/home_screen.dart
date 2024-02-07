import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streaming_data_dashboard/core/utilities/constants.dart';
import 'package:streaming_data_dashboard/features/home/bloc/home_bloc.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.isAdmin});

  final HomeBloc homeBloc = sl.get<HomeBloc>();
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    List<Plant> plants = [];

    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is NavigateToSettingsPageActionState) {
          context.pushNamed("Settings");
        }
        if (state is NavigateToDashboardPageActionState) {
          context.pushNamed("Dashboard", extra: state.plant);
        }
        if (state is LogoutSuccessState) {
          context.go("/login");
        }
      },
      builder: (context, state) {
        Widget body = const Center(
          child: CircularProgressIndicator(),
        );
        if (state is HomeInitial) {
          homeBloc.add(HomeDataFetchEvent());
        } else if (state is HomeLoadingState) {
          body = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoadingSuccessState) {
          plants = state.plants;

          body = loadedBody(plants);
        } else if (state is HomeLoadingFailedState) {
          body = const Center(
            child: Text("Error!"),
          );
        }
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "APL Dashboard",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
              ),
              actions: [
                // IconButton(
                //   onPressed: isAdmin
                //       ? () {
                //           homeBloc.add(SettingsButtonOnClickedEvent());
                //         }
                //       : null,
                //   icon: const Icon(
                //     Icons.more_vert,
                //   ),
                //   iconSize: 40,
                // )
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Settings') {
                      homeBloc.add(SettingsButtonOnClickedEvent());
                    } else if (value == 'Logout') {
                      homeBloc.add(LogoutButtonClickedEvent());
                      // Handle logout action
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Settings',
                        enabled: isAdmin,
                        child: const ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Logout',
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                        ),
                      ),
                    ];
                  },
                )
              ]),
          body: body,
        );
      },
    );
  }

  SizedBox loadedBody(List<Plant> plants) {
    Map<String, String> images = plantDictionary;

    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 20,
            runSpacing: 25,
            alignment: WrapAlignment.start,
            // runAlignment: WrapAlignment.spaceEvenly,
            // crossAxisAlignment: WrapCrossAlignment.start,
            children: plants
                .map<Widget>((plant) => PlantItemWidget(
                      image: images[plant.name] ?? images["Mundra"]!,
                      plant: plant,
                      onTap: () {
                        homeBloc.add(OnPlantClickedEvent(plant: plant));
                      },
                    ))
                .toList()
              ..add(const SizedBox(
                height: 20,
                width: double.maxFinite,
              )),
          ),
        ),
      ),
    );
  }
}

class PlantItemWidget extends StatefulWidget {
  const PlantItemWidget({
    super.key,
    required this.plant,
    required this.image,
    required this.onTap,
  });

  final Plant plant;
  final String image;
  final void Function() onTap;

  @override
  State<PlantItemWidget> createState() => _PlantItemWidgetState();
}

class _PlantItemWidgetState extends State<PlantItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> _animation =
      Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height / 3.3;
    double width = size.width / 3.3;
    return InkWell(
      // onSecondaryTapUp: (details) {},
      onTap: widget.onTap,
      onHover: (value) {
        if (value) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _animation.value * 0.08 + 1,
            child: child,
          );
        },
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(widget.image),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 4.0,
                spreadRadius: 0.0,
                offset: Offset(7.0, 7.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // FadeTransition(
              //   opacity: _animation,
              //   child: ClipRRect(
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              //       child: Container(
              //         height: height / 7,
              //         width: double.maxFinite,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           gradient: const LinearGradient(
              //               colors: [Colors.black26, Colors.transparent],
              //               begin: Alignment.topCenter,
              //               end: Alignment.bottomCenter),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             IconButton(
              //               onPressed: () {},
              //               icon: const Icon(Icons.delete_rounded),
              //               splashRadius: 5,
              //               color: Colors.grey.shade600,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    height: height / 4,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(193, 0, 0, 0),
                            Color.fromARGB(56, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 2, right: 10, left: 10),
                              child: Text.rich(TextSpan(
                                  text: "Total Generation\n",
                                  style: TextStyle(
                                    fontSize: height / 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: widget.plant.totalGeneration
                                            .toStringAsFixed(0),
                                        style: TextStyle(
                                            fontSize: height / 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500))
                                  ])),
                            )),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, right: 10, left: 10),
                              child: Text(
                                widget.plant.name,
                                style: TextStyle(
                                    fontSize: size.height / 30,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              // Align(
              //     alignment: Alignment.bottomRight,
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Text(
              //         widget.plant.name,
              //         style: TextStyle(
              //             fontSize: size.height / 30,
              //             fontWeight: FontWeight.w900,
              //             color: Colors.white),
              //       ),
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
