part of 'analytic_bloc.dart';

abstract class AnalyticEvent extends Equatable {
  const AnalyticEvent();

  @override
  List<Object> get props => [];
}

class AnalyticLoadExpenses extends AnalyticEvent {}

class AnalyticLoadIncome extends AnalyticEvent {}

class AnalyticLoadWeek extends AnalyticEvent {}

class AnalyticLoadMonth extends AnalyticEvent {}

class AnalyticLoadYear extends AnalyticEvent {}

class AnalyticLoadAllTheTime extends AnalyticEvent {}
