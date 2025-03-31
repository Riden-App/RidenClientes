import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:ride_usuario/enums/categori.dart';
import 'package:ride_usuario/models/response/create_trip_response.dart';
import 'package:ride_usuario/models/response/detail_trip_response.dart';
import 'package:ride_usuario/models/response/location_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  factory PreferenciasUsuario() {
    _instancia ??= PreferenciasUsuario._internal();
    return _instancia!;
  }
  PreferenciasUsuario._internal();
  static PreferenciasUsuario? _instancia;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set paymentMethod(String value) => _prefs.setString('paymentMethod', value);
  String get paymentMethod => _prefs.getString('paymentMethod') ?? '';

  set selectedMethodPayment(int value) =>
      _prefs.setInt('selectedMethodPayment', value);
  int get selectedMethodPayment => _prefs.getInt('selectedMethodPayment') ?? 1;

  set oferta(String value) => _prefs.setString('oferta', value);
  String get oferta => _prefs.getString('oferta') ?? '0';

  set kmTrip(String value) => _prefs.setString('kmTrip', value);
  String get kmTrip => _prefs.getString('kmTrip') ?? '0';

  set categoryTrip(String value) => _prefs.setString('categoryTrip', value);
  String get categoryTrip =>
      _prefs.getString('categoryTrip') ?? RideCategory.standard.value;

  set lugarInicio(String value) => _prefs.setString('lugarInicio', value);
  String get lugarInicio => _prefs.getString('lugarInicio') ?? '';

  set lugarFin(String value) => _prefs.setString('lugarFin', value);
  String get lugarFin => _prefs.getString('lugarFin') ?? '';

  set ltLnInicio(String value) => _prefs.setString('ltLnInicio', value);
  String get ltLnInicio => _prefs.getString('ltLnInicio') ?? '';

  set ltLnFin(String value) => _prefs.setString('ltLnFin', value);
  String get ltLnFin => _prefs.getString('ltLnFin') ?? '';

  set roomID(String value) => _prefs.setString('roomID', value);
  String get roomID => _prefs.getString('roomID') ?? '';

  set priceTrip(String value) => _prefs.setString('priceTrip', value);
  String get priceTrip => _prefs.getString('priceTrip') ?? '0';

  set idGoogle(String idGoogle) {}

  set referralCode(String value) => _prefs.setString('referralCode', value);
  String get referralCode => _prefs.getString('referralCode') ?? '';

  set detailTrip(String value) => _prefs.setString('detailTrip', value);
  String get detailTrip => _prefs.getString('detailTrip') ?? '';

  set tripType(String value) => _prefs.setString('tripType', value);
  String get tripType => _prefs.getString('tripType') ?? 'passenger';

  set contactEmisor(String value) => _prefs.setString('contactEmisor', value);
  String get contactEmisor => _prefs.getString('contactEmisor') ?? '';

  set contacReceptor(String value) => _prefs.setString('contacReceptor', value);
  String get contacReceptor => _prefs.getString('contacReceptor') ?? '';

  set totalStops(int value) => _prefs.setInt('totalStops', value);
  int get totalStops => _prefs.getInt('totalStops') ?? 0;

  set actualStop(int value) => _prefs.setInt('actualStop', value);
  int get actualStop => _prefs.getInt('actualStop') ?? 1;

  set idTokenGoogle(String value) => _prefs.setString('idTokenGoogle', value);
  String get idTokenGoogle => _prefs.getString('idTokenGoogle') ?? '';

  set idTokenFacebook(String value) =>
      _prefs.setString('idTokenFacebook', value);
  String get idTokenFacebook => _prefs.getString('idTokenFacebook') ?? '';

  set accessTokenGoogle(String value) =>
      _prefs.setString('accessTokenGoogle', value);
  String get accessTokenGoogle => _prefs.getString('accessTokenGoogle') ?? '';

  set phoneNumberGoogleFacebook(String value) =>
      _prefs.setString('phoneNumberGoogleFacebook', value);
  String get phoneNumberGoogleFacebook =>
      _prefs.getString('phoneNumberGoogleFacebook') ?? '';

  // START: Variables para validacion de login
  set tokenFirebase(String value) => _prefs.setString('tokenFirebase', value);
  String get tokenFirebase => _prefs.getString('tokenFirebase') ?? '';

  set isAuthenticated(bool value) => _prefs.setBool('isAuthenticated', value);
  bool get isAuthenticated => _prefs.getBool('isAuthenticated') ?? false;

  // END: Variables para validacion de login

  saveUserData({
    String? idUser,
    String? accessToken,
    String? refreshToken,
    String? phoneNumber,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    _prefs.setString('idUser', idUser ?? '');
    _prefs.setString('token', accessToken ?? '');
    _prefs.setString('pnToken', refreshToken ?? '');
    _prefs.setString('phoneNumber', phoneNumber ?? '');
    _prefs.setString('email', email ?? '');
    _prefs.setString('firstName', firstName ?? '');
    _prefs.setString('lastName', lastName ?? '');
  }

  String get idUser => _prefs.getString('idUser') ?? '';
  String get accessToken => _prefs.getString('token') ?? '';
  String get refreshToken => _prefs.getString('pnToken') ?? '';
  String get phoneNumber => _prefs.getString('phoneNumber') ?? '';
  String get email => _prefs.getString('email') ?? '';
  String get firstName => _prefs.getString('firstName') ?? '';
  String get lastName => _prefs.getString('lastName') ?? '';

  set fcmToken(String value) => _prefs.setString('fcmToken', value);
  String get fcmToken => _prefs.getString('fcmToken') ?? '';

  set createTripResponse(TripCreateResponse response) {
    _prefs.setString('detailTripResponse', response.toRawJson());
  }

  TripCreateResponse get createTripResponse {
    final response = _prefs.getString('detailTripResponse');
    if (response != null) {
      return TripCreateResponse.fromRawJson(response);
    }
    return TripCreateResponse(
        status: '',
        data: DataCreateTrip(
            id: '',
            userId: -1,
            driverUserId: '',
            pickupLocation: LocationCreate(
              lat: 0,
              lng: 0,
              name: '',
              sequence: -1,
            ),
            dropoffLocations: <LocationCreate>[
              LocationCreate(
                lat: 0,
                lng: 0,
                name: '',
                sequence: -1,
              )
            ],
            paymentMethod: '',
            requestType: '',
            offer: 0,
            tripDetail: '',
            tripType: '',
            tripClass: '',
            tripState: '',
            senderMobile: null,
            receiverMobile: null));
  }

  set detailTripResponse(DetailTripResponse response) {
    _prefs.setString('detailTripResponse', response.toRawJson());
  }

  DetailTripResponse get detailTripResponse {
    final jsonString = _prefs.getString('detailTripResponse');
    if (jsonString != null) {
      return DetailTripResponse.fromJson(json.decode(jsonString));
    }
    return DetailTripResponse(
      status: 'default',
      data: Data(
        id: '',
        userId: -1,
        user: UserResponse(
          id: -1,
          firstName: '',
          lastName: '',
          email: '',
          mobile: '',
          latitude: 0,
          longitude: 0,
          userRoles: [],
          ratingAverageDriver: 0,
          ratingAveragePassenger: 0,
          profilePictureUrl: '',
        ),
        driverUserId: 0,
        pickupLocation: Location(name: '', lat: 0, lng: 0, sequence: 0),
        dropoffLocations: [],
        paymentMethod: '',
        requestType: '',
        offer: 0,
        amount: 0,
        vehicle: VehicleData(
            id: 0,
            userId: 0,
            vehicleColor: '',
            vehicleType: '',
            vehicleModelId: 0,
            vehicleMakeId: 0,
            year: 0,
            vehiclePhotoUrl: '',
            insuranceTrafficAccidentsUrl: '',
            plateNumber: '',
            tripClasses: [],
            state: '',
            createUid: 0,
            writeUid: 0,
            createdAt: '',
            updatedAt: ''),
        tripDetail: '',
        tripType: '',
        tripClass: '',
        tripState: '',
        senderMobile: '',
        receiverMobile: '',
        driverUser: UserResponse(
          id: -1,
          firstName: '',
          lastName: '',
          email: '',
          mobile: '',
          latitude: 0,
          longitude: 0,
          userRoles: [],
          ratingAverageDriver: 0,
          ratingAveragePassenger: 0,
          profilePictureUrl: '',
        ),
      ),
    );
  }

  set locationResponse(LocationResponse response) {
    _prefs.setString('detailTripResponse', response.toRawJson());
  }

  LocationResponse get locationResponse {
    final jsonString = _prefs.getString('detailTripResponse');
    if (jsonString != null) {
      return LocationResponse.fromJson(json.decode(jsonString));
    }
    return LocationResponse(
      status: 'default',
      data: DataLocationResponse(
        id: -1,
        firstName: '',
        lastName: '',
        email: '',
        mobile: '',
        latitude: 0,
        longitude: 0,
        userRoles: [],
        ratingAverageDriver: 0,
        ratingAveragePassenger: 0,
      ),
    );
  }
}
