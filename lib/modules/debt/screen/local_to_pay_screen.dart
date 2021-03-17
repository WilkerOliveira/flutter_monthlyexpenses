import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/model/local_to_pay_model.dart';
import 'package:summarizeddebts/modules/debt/controller/local_to_pay_controller.dart';
import 'package:summarizeddebts/modules/debt/screen/widget/local_to_pay_list_widget.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/textformfield/custom_text_form_field.dart';

class LocalToPayScreen extends StatefulWidget {
  LocalToPayScreen({Key key}) : super(key: key);

  @override
  _LocalToPayScreenState createState() {
    return _LocalToPayScreenState();
  }
}

class _LocalToPayScreenState
    extends ModularState<LocalToPayScreen, LocalToPayController>
    with CommonFormValidation {
  final _formKey = GlobalKey<FormState>();
  LocalToPayModel _localToPayModel = LocalToPayModel();
  TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();

    //Load only when build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;

    return Scaffold(
      appBar: CustomAppBar(
        appBarType: AppBarType.simple,
        title: S.of(context).local_to_pay,
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.of(context).save,
            onPressed: this.save,
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    CustomTextFormField descriptionField = CustomTextFormField(
      controller: this.descriptionController,
      type: TextFormType.simple,
      maxLength: 50,
      validator: requiredField,
      onFieldSubmitted: (term) {},
      onSaved: (String value) {
        _localToPayModel.description = value.trim();
      },
      textInputAction: TextInputAction.done,
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(AppDimen.adMargin),
        top: ScreenUtil().setWidth(AppDimen.defaultMargin),
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(AppDimen.defaultMargin),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).description,
                        style: AppStyles.defaultTextStyle(),
                      ),
                    ),
                  ),
                  descriptionField,
                  SizedBox(
                    height: ScreenUtil().setHeight(AppDimen.defaultMargin),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.sizedBoxSpace),
          ),
          Observer(
            builder: (context) {
              return LocalToPayListWidget(
                items: controller.items,
                onDeletePressed: this.onDelete,
                onEditPressed: this.onEdit,
              );
            },
          ),
        ],
      ),
    );
  }

  save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      AlertDialogs.showLoading(context, S.of(context).please_wait);

      await controller.save(this._localToPayModel);

      AlertDialogs.closeDialog(context);

      if (this.controller.isError) {
        AlertDialogs.showErrorDialog(
            context, S.of(context).app_name, controller.errorMessage);
      } else {
        this.descriptionController.text = "";
        this._localToPayModel = LocalToPayModel();

        AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
            S.of(context).local_to_pay_saved_success, () {});
      }
    }
  }

  Future<void> loadData() async {
    AlertDialogs.showLoading(context, S.of(context).please_wait);

    await controller.consult();

    AlertDialogs.closeDialog(context);

    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).app_name, controller.errorMessage);
    }
  }

  onEdit(index) {
    this._localToPayModel = controller.items[index];
    this.descriptionController.text = this._localToPayModel.description;
  }

  onDelete(index) {
    AlertDialogs.showYesOrNoQuestion(
        context: context,
        title: S.of(context).confirm,
        message: S.of(context).confirm_delete_item,
        textButtonOne: S.of(context).yes.toUpperCase(),
        textButtonTwo: S.of(context).no.toUpperCase(),
        yesCallBackFunction: () async {
          await this.controller.delete(index);

          if (!this.controller.isError) {
            AlertDialogs.showSuccessDialog(context, S.of(context).success_title,
                S.of(context).register_delete_successfully, () {});
          } else {
            if (this.controller.errorMessage == null) {
              AlertDialogs.showErrorMessageDialog(
                  context,
                  S.of(context).app_name,
                  S.of(context).could_not_delete_register);
            } else {
              AlertDialogs.showErrorDialog(context, S.of(context).app_name,
                  this.controller.errorMessage);
            }
          }
        });
  }
}
