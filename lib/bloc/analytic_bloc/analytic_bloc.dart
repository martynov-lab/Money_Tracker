import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/data/models/chart_data.dart';
import 'package:money_tracker/data/models/transaction.dart';
import 'package:money_tracker/data/repository/list_colors_category.dart';
import 'package:money_tracker/data/repository/transaction_repository.dart';

part 'analytic_bloc_event.dart';
part 'analytic_bloc_state.dart';

class AnalyticBloc extends Bloc<AnalyticEvent, AnalyticState> {
  final TransactionRepository _transactionRepository;
  AnalyticBloc(this._transactionRepository) : super(AnalyticEmptyState());

  @override
  Stream<AnalyticState> mapEventToState(AnalyticEvent event) async* {
    if (event is AnalyticLoadExpenses) {
      yield* _mapLoadMonthAnalyticToState('expenditure');
    } else if (event is AnalyticLoadIncome) {
      yield* _mapLoadMonthAnalyticToState('income');
    }
  }

  Stream<AnalyticState> _mapLoadMonthAnalyticToState(String typeEvent) async* {
    try {
      yield AnalyticLoadingState();

      List<MyTransaction>? transaction =
          await _transactionRepository.fetchTransaction();

      if (transaction.isEmpty) {
        yield AnalyticEmptyState();
      } else {
        //* Групперовка транзакций по категории
        var transactionGroupCategory =
            groupBy(transaction, (MyTransaction obj) => obj.categoryName);
        //* Подготовка данных для диаграммы
        String? _nameSegmentChart;
        var sumTransactionPerMonth = 0.0;
        var index = 0;
        final chartData = <ChartData>[];
        DateTime nowDate = DateTime.now();
        DateFormat formatterDate = DateFormat('MM');
        late String currentMonth = formatterDate.format(nowDate);
        transactionGroupCategory.forEach((key, value) {
          //* название сегмента
          _nameSegmentChart = key;
          var _valueSegmentChart = 0.0;
          var colors = ColorsCategory();
          //* значение сегмента
          value.forEach((transaction) {
            var amount = transaction.amount;
            if (transaction.typeTransaction == typeEvent &&
                transaction.currentDate!.substring(3, 5) == currentMonth) {
              _valueSegmentChart += double.parse(amount!);
            }
          });
          //* цвет сегмента
          if (_valueSegmentChart != 0.0) {
            chartData.add(ChartData(_nameSegmentChart!, _valueSegmentChart,
                colors.colorsCategory[index]));
          }

          index++;
          sumTransactionPerMonth += _valueSegmentChart;
        });

        //* текущий месяц
        switch (currentMonth) {
          case '01':
            currentMonth = 'январь';
            break;
          case '02':
            currentMonth = 'февраль';
            break;
          case '03':
            currentMonth = 'март';
            break;
          case '04':
            currentMonth = 'апрель';
            break;
          case '05':
            currentMonth = 'май';
            break;
          case '06':
            currentMonth = 'июнь';
            break;
          case '07':
            currentMonth = 'июль';
            break;
          case '08':
            currentMonth = 'август';
            break;
          case '09':
            currentMonth = 'сентябрь';
            break;
          case '10':
            currentMonth = 'октябрь';
            break;
          case '11':
            currentMonth = 'ноябрь';
            break;
          case '12':
            currentMonth = 'декабрь';
            break;
          default:
        }
        yield AnalyticLoadedState(
          chartData,
          sumTransactionPerMonth.toString(),
          currentMonth,
        );
      }
    } catch (e) {
      print('Ошибка: $e');
      yield AnalyticErrorState();
    }
  }
}
