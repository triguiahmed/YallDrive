part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initFirebase();
  await _initHive();

  serviceLocator.registerFactory(
    () => AppUserCubit(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  _initSplash();
  _initAuth();
  _initProfile();
  _initRegister();
  _initBooking();
}

Future<void> _initFirebase() async {
  // Auth
  final firebaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton<FirebaseAuth>(
    () => firebaseAuth,
  );

  // FireStore
  final firebaseFirestore = FirebaseFirestore.instance;
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
    () => firebaseFirestore,
  );

  // FireStorage
  final firebaseStorage = FirebaseStorage.instance;
  serviceLocator.registerLazySingleton<FirebaseStorage>(
    () => firebaseStorage,
  );

  // FireMessaging
  final firebaseMessaging = FirebaseMessaging.instance;
  serviceLocator.registerLazySingleton<FirebaseMessaging>(
    () => firebaseMessaging,
  );

  await _initializeFirebaseMessaging();
}

Future<void> _initializeFirebaseMessaging() async {
  final messaging = serviceLocator<FirebaseMessaging>();

  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    debugPrint("❌ User denied push notifications.");
    return;
  }

  // Retrieve FCM Token
  String? fcmToken = await messaging.getToken();
  if (fcmToken != null) {
    debugPrint("✅ FCM Token: $fcmToken");
    // Send this token to your backend for user-device mapping
  } else {
    debugPrint("⚠️ Failed to get FCM Token");
  }

  // subcribe
  messaging.subscribeToTopic('user');

  // Handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint("📩 Foreground Notification: ${message.notification?.title}");
  });

  // Handle when app is opened via notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("🔄 App opened from notification.");
  });

  // Handle when app is launched from a notification
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    debugPrint(
        "🚀 App launched from notification: ${initialMessage.notification?.title}");
  }
}

Future<void> _initHive() async {
  try {
    await Hive.initFlutter();
    final box = await Hive.openBox('recently_viewed_cars');

    if (!serviceLocator.isRegistered<Box>()) {
      serviceLocator.registerSingleton<Box>(box);
    }
  } catch (e) {
    debugPrint('Hive initialization failed: $e');
  }
}

void _initSplash() {
  serviceLocator
    ..registerLazySingleton<GetInitialData>(
      () => GetInitialData(),
    )
    ..registerFactory<SplashBloc>(
      () => SplashBloc(
        serviceLocator(),
      ),
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<UserSignup>(
      () => UserSignup(
        serviceLocator(),
      ),
    )
    ..registerFactory<UserLogin>(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory<CurrentUser>(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initRegister() {
  serviceLocator
    ..registerFactory<RegisterRemoteDataSource>(
      () => RegistorRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<RegisterRepository>(
      () => RegisterRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<RegisterCarDetails>(
      () => RegisterCarDetails(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetCarsByLocation(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetCarById(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllCars(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => RegisterBloc(
        registerCarDetails: serviceLocator(),
        getCarsByLocation: serviceLocator(),
        getCarById: serviceLocator(),
        getAllCars: serviceLocator(),
      ),
    );
}

void _initProfile() {
  serviceLocator
    ..registerFactory<ProfileRemoteDataSources>(
      () => ProfileRemoteDataSourcesImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<EditUserData>(
      () => EditUserData(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetCustomerData>(
      () => GetCustomerData(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetOwnerData>(
      () => GetOwnerData(
        serviceLocator(),
      ),
    )
    ..registerFactory<CheckCarBooked>(
      () => CheckCarBooked(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton<ProfileBloc>(
      () => ProfileBloc(
        editUserData: serviceLocator(),
        customerData: serviceLocator(),
        ownerData: serviceLocator(),
        carBooked: serviceLocator(),
      ),
    );
}

void _initBooking() {
  serviceLocator
    ..registerFactory<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BookingRepository>(
      () => BookingRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BookingCar>(
      () => BookingCar(
        serviceLocator(),
      ),
    )
    ..registerFactory<OwnerRequestApprove>(
      () => OwnerRequestApprove(
        serviceLocator(),
      ),
    )
    ..registerFactory<ShowBookingForCar>(
      () => ShowBookingForCar(
        serviceLocator(),
      ),
    )
    ..registerFactory<ShowBookingForOwner>(
      () => ShowBookingForOwner(
        serviceLocator(),
      ),
    )
    ..registerFactory<ShowBookingForUser>(
      () => ShowBookingForUser(
        serviceLocator(),
      ),
    )
    ..registerFactory<PaymentApprove>(
      () => PaymentApprove(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BookingBloc(
        bookingCar: serviceLocator(),
        ownerRequestApprove: serviceLocator(),
        bookingForCar: serviceLocator(),
        bookingForOwner: serviceLocator(),
        bookingForUser: serviceLocator(),
        paymentApprove: serviceLocator(),
      ),
    );
}
