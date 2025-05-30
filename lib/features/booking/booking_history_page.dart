import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/features/booking/bloc/booking_history_bloc.dart';
import 'package:flutter_clean_architecture_practise/features/booking/bloc/booking_history_state.dart';
import 'package:flutter_clean_architecture_practise/features/booking/repository/booking_repository.dart';

class BookingHistoryPage extends StatelessWidget {
  final String userId;
  static Route<MaterialPageRoute> route(String userId) =>
      MaterialPageRoute(builder: (_) => BookingHistoryPage(userId: userId));
  const BookingHistoryPage({Key? key, required this.userId}) : super(key: key);

  Map<String, dynamic> _getStatus(DateTime expiresAt) {
    final now = DateTime.now();
    if (now.isBefore(expiresAt)) {
      return {
        'label': 'В Процессе',
        'color': AppPallete.darkGreen,
      };
    } else {
      return {
        'label': 'Отменено',
        'color': AppPallete.error,
      };
    }
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.$y $h:$mi';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingHistoryBloc(
        repo: BookingRepository(),
        userId: userId,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppPallete.black,
              )),
          title: const Text(
            'История Бронирования',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
          builder: (context, state) {
            if (state is BookingHistoryLoading ||
                state is BookingHistoryInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppPallete.darkGreen),
                ),
              );
            }

            if (state is BookingHistoryError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppPallete.error),
                ),
              );
            }

            if (state is BookingHistoryLoaded) {
              final bookings = state.items;

              if (bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 139,
                        height: 139,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppPallete.darkGreen.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/nonebook.jpg',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Вы ещё не бронировали валюту. Начните с поиска подходящего обменника на главной странице.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppPallete.darkGreen,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final statusInfo = _getStatus(booking.expiresAt);
                  final statusLabel = statusInfo['label'] as String;
                  final statusColor = statusInfo['color'] as Color;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppPallete.gradientStart,
                          AppPallete.gradientEnd
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: AppPallete.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Валюта: ${booking.currency}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppPallete.darkGreen,
                                  ),
                                ),
                                Text(
                                  '${booking.amount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppPallete.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Дата и время: ${_formatDateTime(booking.createdAt)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppPallete.darkGreen,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Пункт обмена: ${booking.exchangePoint}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppPallete.darkGreen,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text(
                                  'Статус: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppPallete.darkGreen,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    statusLabel,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
