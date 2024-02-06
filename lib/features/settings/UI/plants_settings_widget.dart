import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streaming_data_dashboard/core/utilities/plant_dialog.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

class PlantsAndUnitSettings extends StatelessWidget {
  PlantsAndUnitSettings({super.key});

  final SettingsBloc settingsBloc = sl.get<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Plant> plants = [];
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: settingsBloc,
      listenWhen: (previous, current) => current is SettingsActionState,
      buildWhen: (previous, current) => current is! SettingsActionState,
      listener: (context, state) {
        if (state is NavigateToUnitEditPageActionState) {
          context.push("/edit-units", extra: state.plant);
        }
        if (state is OpenAddPlantDialogState) {
          showDialog(
            context: context,
            builder: (context) {
              return PlantDialog();
            },
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsInitial) {
          settingsBloc.add(PlantDataFetchEvent());
        } else if (state is PlantLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PlantLoadingFailedState) {
          return Center(child: Text("Error"));
        } else if (state is PlantLoadingSuccessState) {
          plants = state.plants;
        }
        if (state is AddPlantSuccessState) {
          print(state.plant.name);
          plants.add(state.plant);
        } else if (state is OnDeletePlantSuccessState) {
          settingsBloc.add(PlantDataFetchEvent());
        }
        return Column(
          children: [
            SizedBox(
              height: size.height / 10,
              width: double.maxFinite,
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "   Adani Thermal Power Plants",
                    style: TextStyle(
                      fontSize: size.height / 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          settingsBloc.add(ButtonAddPlantClickedEvent());
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_location_alt_rounded),
                            Text(
                              "Add Plant",
                              style: TextStyle(
                                fontSize: size.height / 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 25,
                    alignment: WrapAlignment.center,
                    // runAlignment: WrapAlignment.spaceEvenly,
                    // crossAxisAlignment: WrapCrossAlignment.start,
                    children: plants
                        .map<Widget>((plant) => PlantItemWidget(
                              plant: plant,
                              onTap: () {
                                settingsBloc
                                    .add(OnPlantClickedEvent(plant: plant));
                              },
                              onDelete: () {
                                settingsBloc.add(ButtonDeletePlantClickedEvent(
                                    plant: plant));
                              },
                            ))
                        .toList()
                      ..add(const SizedBox(
                        height: 20,
                        width: double.maxFinite,
                      ))
                      ..insert(
                          0,
                          const SizedBox(
                            height: 5,
                            width: double.maxFinite,
                          )),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PlantItemWidget extends StatefulWidget {
  const PlantItemWidget({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onDelete,
  });

  final Plant plant;
  final void Function() onTap;
  final void Function() onDelete;

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
    double height = size.height / 4;
    double width = size.width / 4;
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
            image: const DecorationImage(
              image: NetworkImage(
                  "https://www.adanipower.com/-/media/Project/Power/OperationalPowerPlants/mundra/Hi-tech-Infra/mundra2"),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeTransition(
                opacity: _animation,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      height: height / 7,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                            colors: [Colors.black26, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.onDelete();
                            },
                            icon: const Icon(Icons.delete_rounded),
                            splashRadius: 5,
                            color: Colors.grey.shade600,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
    );
  }
}
