import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
part "base_controller.g.dart";

/// Represents the state of the view
enum ViewState { Idle, Busy }

class BaseController = BaseControllerBase with _$BaseController;

abstract class BaseControllerBase with Store {
  @observable
  ViewState _state = ViewState.Idle;

  @observable
  ViewState _secondState = ViewState.Idle;

  ViewState get viewState => this._state;

  ViewState get secondViewState => this._secondState;

  @protected
  bool error;
  @protected
  bool alert;
  @protected
  ExceptionMessages customErrorMessage;

  bool isEditing = false;

  bool get isError => error;

  bool get isAlert => alert;

  ExceptionMessages get errorMessage => customErrorMessage;

  @action
  void setState(ViewState viewState) {
    _state = viewState;
  }

  @action
  void setSecondState(ViewState viewState) {
    _secondState = viewState;
  }

  void logError(ex) {
    print(ex.toString());
  }
}
