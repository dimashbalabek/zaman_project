// lib/bloc/booking_history_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import '../models/booking_history_item.dart';
import '../repository/booking_repository.dart';

import 'booking_history_event.dart';
import 'booking_history_state.dart';

const String bookingBoxName = 'bookingHistoryBox';

class BookingHistoryBloc
    extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  late Box<BookingHistoryItem> _box;
  Timer? _timer;
  final BookingRepository _repo;

  BookingHistoryBloc({required BookingRepository repo, required String userId})
      : _repo = repo,
        super(BookingHistoryInitial()) {
    on<LoadBookingHistory>(_onLoadBookingHistory);
    on<CheckStatusesEvent>(_onCheckStatuses);

    _initBoxAndLoad(userId);
  }

  Future<void> _initBoxAndLoad(String userId) async {
    try {
      _box = Hive.box<BookingHistoryItem>(bookingBoxName);

      await _repo.fetchAndSaveFromFirebase(userId);

      add(LoadBookingHistory());

      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        add(CheckStatusesEvent());
      });
    } catch (e) {
      addError('Ошибка при инициализации BLoC: $e');
    }
  }

  Future<void> _onLoadBookingHistory(
      LoadBookingHistory event, Emitter<BookingHistoryState> emit) async {
    emit(BookingHistoryLoading());
    try {
      final rawList = _box.values.toList();
      emit(BookingHistoryLoaded(rawList));
    } catch (e) {
      emit(BookingHistoryError('Не удалось загрузить историю: $e'));
    }
  }

  Future<void> _onCheckStatuses(
      CheckStatusesEvent event, Emitter<BookingHistoryState> emit) async {
    try {
      final updatedList = _box.values.toList();
      emit(BookingHistoryLoaded(updatedList));
    } catch (e) {
      emit(BookingHistoryError('Ошибка при обновлении статусов: $e'));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
