part of 'analytic_bloc.dart';

abstract class AnalyticState extends Equatable {
  const AnalyticState();

  @override
  List<Object> get props => [];
}

class AnalyticEmptyState extends AnalyticState {}

class AnalyticLoadingState extends AnalyticState {}

class AnalyticLoadedState extends AnalyticState {
  final List<ChartData> chartData;
  final String sumTransactionPerMonth;
  final String currentMonth;

  const AnalyticLoadedState(
      this.chartData, this.sumTransactionPerMonth, this.currentMonth);

  @override
  List<Object> get props => [chartData, sumTransactionPerMonth, currentMonth];

  // @override
  // String toString() => 'TrasactionLoaded { trasaction: $loadedTrasaction }';
}

class AnalyticErrorState extends AnalyticState {}
