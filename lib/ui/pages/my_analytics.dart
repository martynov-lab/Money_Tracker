import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/analytic_bloc/analytic_bloc.dart';
import 'package:money_tracker/data/models/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyAnalytics extends StatefulWidget {
  @override
  State<MyAnalytics> createState() => _MyAnalyticsState();
}

class _MyAnalyticsState extends State<MyAnalytics> {
  late bool isExpenses;
  @override
  void initState() {
    super.initState();
    isExpenses = true;
  }

  @override
  Widget build(BuildContext context) {
    final analyticBloc = BlocProvider.of<AnalyticBloc>(context);

    isExpenses
        ? analyticBloc.add(
            AnalyticLoadExpenses(),
          )
        : analyticBloc.add(
            AnalyticLoadIncome(),
          );

    void _onFormSubmitted() {
      setState(() {
        isExpenses = !isExpenses;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 4,
        centerTitle: false,
        title: Text(
          'Аналитика',
          style: TextStyle(fontSize: 20.0),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[400],
                onPrimary: Colors.white,
                //enableFeedback: true,
                //tapTargetSize: MaterialTapTargetSize.padded,
                //animationDuration: Duration(milliseconds: 100),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onPressed: _onFormSubmitted,
              child: isExpenses ? Text('ДОХОДЫ') : Text('РАСХОДЫ'),
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<AnalyticBloc, AnalyticState>(builder: (context, state) {
        if (state is AnalyticEmptyState) {
          return Center(child: Text('У вас пока нет транзакций'));
        }
        if (state is AnalyticLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is AnalyticLoadedState) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              //Диаграмма
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.grey[300],
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Расходы за ${state.currentMonth}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            Text(
                              '${state.sumTransactionPerMonth} руб',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 0.0,
                        thickness: 1.0,
                      ),
                      Container(
                        margin: const EdgeInsets.all(30),
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: -8,
                              blurRadius: 17,
                              offset: Offset(-5, -5),
                              color: Colors.white,
                            ),
                            BoxShadow(
                              spreadRadius: -2,
                              blurRadius: 10,
                              offset: Offset(7, 7),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: SfCircularChart(
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                  height: '140',
                                  width: '140',
                                  widget: Container(
                                      child: PhysicalModel(
                                          shape: BoxShape.circle,
                                          elevation: 10,
                                          shadowColor: Colors.black,
                                          color: const Color.fromRGBO(
                                              230, 230, 230, 1),
                                          child: Container()))),
                              CircularChartAnnotation(
                                  widget: Container(
                                      child: Text(
                                          '${state.sumTransactionPerMonth} руб',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                              fontSize: 24))))
                            ],
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                dataSource: state.chartData,
                                xValueMapper: (ChartData data, _) =>
                                    data.nameSegment,
                                yValueMapper: (ChartData data, _) =>
                                    data.valueSegment,
                                dataLabelMapper: (ChartData data, _) =>
                                    data.nameSegment,
                                //explode: true, //нажатие на сегмент
                                //explodeIndex: 1,
                                radius: '100%',
                                innerRadius: '50%',
                                dataLabelSettings: DataLabelSettings(
                                  showZeroValue: false,
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  labelPosition: ChartDataLabelPosition.inside,
                                  connectorLineSettings: ConnectorLineSettings(
                                    length: '15%',
                                    type: ConnectorType.line,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              // Список по категориям
              Card(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.grey[300],
                elevation: 4,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ...state.chartData.map(
                        (item) => Column(
                          children: [
                            ListTile(
                              title: Text('${item.nameSegment}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  )),
                              // subtitle: Text(
                              //   '${item.valueSegment} руб',
                              //   style: TextStyle(
                              //     color: Colors.grey,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w300,
                              //   ),
                              // ),
                              // trailing: Icon(
                              //   CupertinoIcons.forward,
                              //   size: 40,
                              //   color: item.color,
                              // ),
                              trailing: Text(
                                '${item.valueSegment} руб',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey[400],
                              height: 0.0,
                              thickness: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Center();
      }),
    );
  }
}
