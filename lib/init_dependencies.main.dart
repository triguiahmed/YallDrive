part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initFirebase();
  await _initHive();

  serviceLocator.registerFactory(
    () => AppUserCubit(
      serviceLocator(),
      serviceLocator(),
      messaging: serviceLocator(),
    ),
  );

  _initSplash();
  _initAuth();
  _initProfile();
  _initRegister();
  _initBooking();
  _initReview();
  _initPayment();
  _initFavorites();
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

  // Notification Service
  serviceLocator.registerLazySingleton<NotificationService>(
    () => NotificationService(serviceLocator()),
  );

  await serviceLocator<NotificationService>().initialize();
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

void _initReview() {
  serviceLocator
    ..registerFactory<ReviewRemoteDataSource>(
      () => ReviewRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<ReviewRepository>(
      () => ReviewRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CreateReview>(
      () => CreateReview(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetReviewsForCar>(
      () => GetReviewsForCar(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetReviewsForCars>(
      () => GetReviewsForCars(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetReviewsByUser>(
      () => GetReviewsByUser(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateReview>(
      () => UpdateReview(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteReview>(
      () => DeleteReview(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAverageRatingForCar>(
      () => GetAverageRatingForCar(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ReviewBloc(
        createReview: serviceLocator(),
        getReviewsForCar: serviceLocator(),
        getReviewsForCars: serviceLocator(),
        getReviewsByUser: serviceLocator(),
        updateReview: serviceLocator(),
        deleteReview: serviceLocator(),
        getAverageRatingForCar: serviceLocator(),
      ),
    );
}

void _initPayment() {
  serviceLocator
    ..registerFactory<PaymentRemoteDataSource>(
      () => PaymentRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<PaymentRepository>(
      () => PaymentRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CreatePayment>(
      () => CreatePayment(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetPaymentForBooking>(
      () => GetPaymentForBooking(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetPaymentsByUser>(
      () => GetPaymentsByUser(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdatePaymentStatus>(
      () => UpdatePaymentStatus(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeletePayment>(
      () => DeletePayment(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => PaymentBloc(
        createPayment: serviceLocator(),
        getPaymentForBooking: serviceLocator(),
        getPaymentsByUser: serviceLocator(),
        updatePaymentStatus: serviceLocator(),
        deletePayment: serviceLocator(),
      ),
    );
}

void _initFavorites() {
  serviceLocator
    ..registerFactory<FavoritesRemoteDataSource>(
      () => FavoritesRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<FavoritesRepository>(
      () => FavoritesRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AddFavorite>(
      () => AddFavorite(
        serviceLocator(),
      ),
    )
    ..registerFactory<RemoveFavorite>(
      () => RemoveFavorite(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetFavoritesByUser>(
      () => GetFavoritesByUser(
        serviceLocator(),
      ),
    )
    ..registerFactory<IsCarFavorited>(
      () => IsCarFavorited(
        serviceLocator(),
      ),
    )
    ..registerFactory<ToggleFavorite>(
      () => ToggleFavorite(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetFavoriteCountForCar>(
      () => GetFavoriteCountForCar(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => FavoritesBloc(
        addFavorite: serviceLocator(),
        removeFavorite: serviceLocator(),
        getFavoritesByUser: serviceLocator(),
        isCarFavorited: serviceLocator(),
        toggleFavorite: serviceLocator(),
        getFavoriteCountForCar: serviceLocator(),
      ),
    );
}

