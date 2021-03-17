import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:summarizeddebts/extensions/double_extensions.dart';
import 'package:summarizeddebts/model/summarized_expenses_model.dart';

class DashboardBarChart extends StatelessWidget {
  final List<SummarizedExpensesModel> debts;
  final bool animate;

  DashboardBarChart({this.debts, this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: new charts.BarChart(
        getSeriesList(),
        animate: animate,
        domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            // Tick and Label styling here.
            labelStyle:
                new charts.TextStyleSpec(color: charts.MaterialPalette.white),
          ),
        ),

        /// Assign a custom style for the measure axis.
        primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
                color: charts.MaterialPalette.green.shadeDefault),
          ),
        ),
        barRendererDecorator: new charts.BarLabelDecorator<String>(),
      ),
    );
  }

  List<charts.Series<SummarizedExpensesModel, String>> getSeriesList() {
    return [
      new charts.Series<SummarizedExpensesModel, String>(
          outsideLabelStyleAccessorFn: (SummarizedExpensesModel sales, _) {
            final color = (sales.total <= 0)
                ? charts.MaterialPalette.yellow.shadeDefault
                : charts.MaterialPalette.white;
            return new charts.TextStyleSpec(color: color);
          },
          id: 'Debts',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (SummarizedExpensesModel sales, _) => sales.type,
          measureFn: (SummarizedExpensesModel sales, _) => sales.total,
          data: this.debts,
          labelAccessorFn: (SummarizedExpensesModel sales, _) =>
              '${sales.total.toCurrency()}')
    ];
  }
}
