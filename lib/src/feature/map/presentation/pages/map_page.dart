import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/core/utils/layout/url_util.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/map/bloc/city_cubit.dart';

@RoutePage()
class MapPage extends StatefulWidget implements AutoRouteWrapper {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CityCubit(repository: context.repository.mapRepository),
        ),
      ],
      child: this,
    );
  }
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CityCubit>(context).getCityDetail(name: 'Алматы');
    _initLocation();
  }

  Future<void> _initLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    final isPermissionGranted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;

    if (isServiceEnabled && isPermissionGranted) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        14,
      ));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет доступа к местоположению пользователя')),
        );
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundInput,
      appBar: AppBar(
        title: Container(
          decoration: const BoxDecoration(color: AppColors.white),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Карта', style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold)),
                Image.asset(Assets.images.logoHeader.path, height: 34),
              ],
            ),
          ),
        ),
        shape: const Border(bottom: BorderSide(color: AppColors.dividerGrey, width: 0.5)),
      ),
      body: BlocBuilder<CityCubit, CityState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const CustomLoadingOverlayWidget(),
            loaded: (cityList) {
              _markers.clear();

              for (final city in cityList) {
                final coordsString = city.coords;
                if (coordsString != null) {
                  final coords = coordsString
                      .replaceAll('[', '')
                      .replaceAll(']', '')
                      .split(',')
                      .map((e) => double.tryParse(e.trim()))
                      .toList();
                  if (coords.length == 2 && coords[0] != null && coords[1] != null) {
                    _markers.add(
                      Marker(
                        markerId: MarkerId(city.address ?? UniqueKey().toString()),
                        position: LatLng(coords[0]!, coords[1]!),
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    );
                  }
                }
              }

              return ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 320,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition != null
                                ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                                : const LatLng(43.238949, 76.889709), // fallback
                            zoom: 12,
                          ),
                          markers: _markers,
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Column(
                            children: [
                              FloatingActionButton(
                                mini: true,
                                heroTag: 'zoom_in',
                                onPressed: () => _mapController?.animateCamera(CameraUpdate.zoomIn()),
                                child: const Icon(Icons.add),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton(
                                mini: true,
                                heroTag: 'zoom_out',
                                onPressed: () => _mapController?.animateCamera(CameraUpdate.zoomOut()),
                                child: const Icon(Icons.remove),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton(
                                mini: true,
                                heroTag: 'my_location',
                                onPressed: _initLocation,
                                child: const Icon(Icons.my_location),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.localized.branches, style: AppTextStyles.fs20w600.copyWith(color: AppColors.red)),
                        InkWell(
                          onTap: () => context.router.push(const AllBranchesRoute()),
                          child: Text('${context.localized.allBranches} ->',
                              style: AppTextStyles.fs14w600.copyWith(color: AppColors.grayText)),
                        ),
                      ],
                    ),
                  ),
                  const Gap(18),
                  ...cityList.map((city) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(city.address ?? 'ERROR ADDRESS',
                                  style: AppTextStyles.fs14w500.copyWith(color: AppColors.black)),
                              const Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('300м', style: AppTextStyles.fs16w400),
                                  Text(city.phones ?? 'ERROR PHONE', style: AppTextStyles.fs14w600),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('закрыто', style: AppTextStyles.fs16w400),
                                      Text(city.time ?? 'ERROR', style: AppTextStyles.fs14w600),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          UrlUtil.launchPhoneUrl(context, phone: city.phones!);
                                        },
                                        child: Image.asset(Assets.images.phone.path, width: 32, height: 32),
                                      ),
                                      const Gap(14),
                                      InkWell(
                                        onTap: () async {
                                          final coordsString = city.coords;
                                          if (coordsString != null) {
                                            final coords = coordsString
                                                .replaceAll('[', '')
                                                .replaceAll(']', '')
                                                .split(',')
                                                .map((e) => e.trim())
                                                .toList();
                                            if (coords.length == 2) {
                                              final lat = coords[0];
                                              final lon = coords[1];
                                              final uri = Uri.parse(
                                                  'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon');
                                              UrlUtil.launch(context, url: uri.toString());
                                            }
                                          }
                                        },
                                        child: Image.asset(Assets.images.a2gis.path, width: 32, height: 32),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(21),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
