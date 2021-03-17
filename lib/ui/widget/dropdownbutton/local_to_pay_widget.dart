import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';

// ignore: must_be_immutable
class LocalToPayWidget extends StatelessWidget {
  final FocusNode focusNode;
  final ObservableList<LocalToPayModel> localToPayList;
  ObservableList<DropdownMenuItem<String>> _localToPayItems =
      ObservableList.of([]);
  final Observable<String> localToPaySelected;

  LocalToPayWidget({
    Key key,
    this.focusNode,
    @required this.localToPayList,
    @required this.localToPaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => DropdownButton<String>(
        style: TextStyle(color: Colors.white),
        focusNode: focusNode,
        isExpanded: true,
        items: mountDropdownMenuItems(context, localToPayList),
        onChanged: (String value) {
          if(focusNode != null)
            ScreenUtility.fieldFocusChange(context, focusNode, focusNode);
          runInAction(() => this.localToPaySelected.value = value);
        },
        hint: Text(S.of(context).select_local_to_pay),
        value: this.localToPaySelected.value,
      ),
    );
  }

  List<DropdownMenuItem<String>> mountDropdownMenuItems(
      context, localToPayList) {
    _localToPayItems = ObservableList.of([]);
    _localToPayItems.add(
      DropdownMenuItem<String>(
        child: Text(S.of(context).select_local_to_pay),
        value: "",
      ),
    );

    if (localToPayList != null) {
      localToPayList.forEach((item) {
        _localToPayItems.add(
          DropdownMenuItem<String>(
            child: Text(
              item.description,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            value: item.id,
          ),
        );
      });
    }

    return _localToPayItems.toList();
  }
}
