// lib/bloc/booking_history_state.dart

import 'package:equatable/equatable.dart';
import '../models/booking_history_item.dart';

abstract class BookingHistoryState extends Equatable {
  const BookingHistoryState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние (например, ничего не загружено).
class BookingHistoryInitial extends BookingHistoryState {}

/// Состояние, когда загружается список.
class BookingHistoryLoading extends BookingHistoryState {}

/// Состояние, когда список загружен (даёт массив items).
class BookingHistoryLoaded extends BookingHistoryState {
  final List<BookingHistoryItem> items;

  const BookingHistoryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Состояние ошибки (если что-то пошло не так).
class BookingHistoryError extends BookingHistoryState {
  final String message;

  const BookingHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
