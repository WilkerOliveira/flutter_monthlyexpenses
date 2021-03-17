// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get app_name {
    return Intl.message("Despesas Mensais", name: 'app_name');
  }

  String get required_field {
    return Intl.message("Campo obrigatório", name: 'required_field');
  }

  String get invalid_email {
    return Intl.message("E-mail inválido", name: 'invalid_email');
  }

  String get email {
    return Intl.message("E-mail", name: 'email');
  }

  String get password {
    return Intl.message("Senha", name: 'password');
  }

  String get btn_login {
    return Intl.message("ENTRAR", name: 'btn_login');
  }

  String get forgot_password {
    return Intl.message("Esqueceu a senha?", name: 'forgot_password');
  }

  String get dont_have_account {
    return Intl.message("Não tem conta?", name: 'dont_have_account');
  }

  String get sign_up_now {
    return Intl.message(" Cadastra-se agora!", name: 'sign_up_now');
  }

  String get invalid_password_format {
    return Intl.message("Deve conter pelo menos 6 caracteres.", name: 'invalid_password_format');
  }

  String get password_not_match {
    return Intl.message("Senhas não conferem!", name: 'password_not_match');
  }

  String get no_internet_connection {
    return Intl.message("Sem conexão com a Internet!", name: 'no_internet_connection');
  }

  String get info_title {
    return Intl.message("Informação", name: 'info_title');
  }

  String get success_title {
    return Intl.message("Sucesso", name: 'success_title');
  }

  String get saved_successfully {
    return Intl.message("Salvo com sucesso", name: 'saved_successfully');
  }

  String get invalid_email_or_password {
    return Intl.message("E-mail ou senha inválidos!", name: 'invalid_email_or_password');
  }

  String get reset_button {
    return Intl.message("ENVIAR SENHA", name: 'reset_button');
  }

  String get default_error {
    return Intl.message("Desculpe, algo deu errado!", name: 'default_error');
  }

  String get user_not_registered {
    return Intl.message("Usuário não cadastrado! Registre-se primeiro.", name: 'user_not_registered');
  }

  String get login_cancelled_by_user {
    return Intl.message("Login cancelado pelo usuário!", name: 'login_cancelled_by_user');
  }

  String get login_title {
    return Intl.message("Login", name: 'login_title');
  }

  String get userRegisteredWithDiffCredential {
    return Intl.message("Você já está registrado com uma credencial diferente!", name: 'userRegisteredWithDiffCredential');
  }

  String get emailNotFound {
    return Intl.message("E-mail não encontrado!", name: 'emailNotFound');
  }

  String get new_password_sent {
    return Intl.message("Uma nova senha foi enviado para seu e-mail!", name: 'new_password_sent');
  }

  String get cancel_button {
    return Intl.message("CANCELAR", name: 'cancel_button');
  }

  String get user_email_already_exist {
    return Intl.message("Já existe um usuário com este e-mail!", name: 'user_email_already_exist');
  }

  String get email_confirmation_sent {
    return Intl.message("Por favor, verifique seu e-mail para confirmar o registro!", name: 'email_confirmation_sent');
  }

  String get invalid_password {
    return Intl.message("Senha atual está inválida!", name: 'invalid_password');
  }

  String get close_button {
    return Intl.message("Fechar", name: 'close_button');
  }

  String get error_title {
    return Intl.message("Erro", name: 'error_title');
  }

  String get btn_register {
    return Intl.message("Registrar", name: 'btn_register');
  }

  String get please_wait {
    return Intl.message("Por favor, espere...", name: 'please_wait');
  }

  String get name {
    return Intl.message("Nome", name: 'name');
  }

  String get confirm_password {
    return Intl.message("Confirmar Senha", name: 'confirm_password');
  }

  String get new_register {
    return Intl.message("Novo usuário", name: 'new_register');
  }

  String get confirm_email {
    return Intl.message("Confirmar E-mail", name: 'confirm_email');
  }

  String get email_not_match {
    return Intl.message("E-mails não são iguais", name: 'email_not_match');
  }

  String get tab_home {
    return Intl.message("Principal", name: 'tab_home');
  }

  String get tab_registers {
    return Intl.message("Despesas", name: 'tab_registers');
  }

  String get tab_consults {
    return Intl.message("Consultas", name: 'tab_consults');
  }

  String get tab_config {
    return Intl.message("Ajustes", name: 'tab_config');
  }

  String get debt_history {
    return Intl.message("Histórico de Despesas", name: 'debt_history');
  }

  String get outstanding_debts {
    return Intl.message("Despesas Pendentes", name: 'outstanding_debts');
  }

  String get debts_paid {
    return Intl.message(" Despesas Pagas", name: 'debts_paid');
  }

  String get january {
    return Intl.message("Janeiro", name: 'january');
  }

  String get february {
    return Intl.message("Fevereiro", name: 'february');
  }

  String get march {
    return Intl.message("Março", name: 'march');
  }

  String get april {
    return Intl.message("Abril", name: 'april');
  }

  String get may {
    return Intl.message("Maio", name: 'may');
  }

  String get june {
    return Intl.message("Junho", name: 'june');
  }

  String get july {
    return Intl.message("Julho", name: 'july');
  }

  String get august {
    return Intl.message("Agosto", name: 'august');
  }

  String get september {
    return Intl.message("Setembro", name: 'september');
  }

  String get october {
    return Intl.message("Outubro", name: 'october');
  }

  String get november {
    return Intl.message("Novembro", name: 'november');
  }

  String get december {
    return Intl.message("Dezembro", name: 'december');
  }

  String get see_more {
    return Intl.message("Veja mais", name: 'see_more');
  }

  String get save {
    return Intl.message("Salvar", name: 'save');
  }

  String get delete {
    return Intl.message("Excluir", name: 'delete');
  }

  String get edit {
    return Intl.message("Editar", name: 'edit');
  }

  String get clear {
    return Intl.message("Limpar", name: 'clear');
  }

  String get due_date {
    return Intl.message("Vencimento", name: 'due_date');
  }

  String get amount {
    return Intl.message("Valor", name: 'amount');
  }

  String get description {
    return Intl.message("Descrição", name: 'description');
  }

  String get local_to_pay {
    return Intl.message("Pagar em", name: 'local_to_pay');
  }

  String get local_to_pay_saved_success {
    return Intl.message("Salvo com sucesso!", name: 'local_to_pay_saved_success');
  }

  String get local_to_pay_exist {
    return Intl.message("Descrição já existe!", name: 'local_to_pay_exist');
  }

  String get no {
    return Intl.message("Não", name: 'no');
  }

  String get yes {
    return Intl.message("Sim", name: 'yes');
  }

  String get confirm {
    return Intl.message("Confirmação", name: 'confirm');
  }

  String get confirm_delete_item {
    return Intl.message("Você tem certeza?", name: 'confirm_delete_item');
  }

  String get register_delete_successfully {
    return Intl.message("Registro excluído com sucesso!", name: 'register_delete_successfully');
  }

  String get could_not_delete_register {
    return Intl.message("Não foi possível excluir o registro!", name: 'could_not_delete_register');
  }

  String get local_to_pay_in_use {
    return Intl.message("Registro em uso", name: 'local_to_pay_in_use');
  }

  String get local_to_pay_not_found {
    return Intl.message("Locais para Pagamentos não encontrados!", name: 'local_to_pay_not_found');
  }

  String get select_local_to_pay {
    return Intl.message("Selecione...", name: 'select_local_to_pay');
  }

  String get plus {
    return Intl.message("+", name: 'plus');
  }

  String get recurring_expenses {
    return Intl.message("Despesa Recorrente", name: 'recurring_expenses');
  }

  String get repeat_for {
    return Intl.message("Repetir por", name: 'repeat_for');
  }

  String get new_expense {
    return Intl.message("Despesa", name: 'new_expense');
  }

  String get invalid_month_year_format {
    return Intl.message("Formato deve ser DD/MM/AAAA", name: 'invalid_month_year_format');
  }

  String get previous {
    return Intl.message("<", name: 'previous');
  }

  String get next {
    return Intl.message(">", name: 'next');
  }

  String get pay {
    return Intl.message("Pagar", name: 'pay');
  }

  String get local_to_pay_not_selected {
    return Intl.message("Local para Pagamento não selecionado!", name: 'local_to_pay_not_selected');
  }

  String get total_amount {
    return Intl.message("Valor total", name: 'total_amount');
  }

  String get reopen {
    return Intl.message("Reabrir", name: 'reopen');
  }

  String get confirm_pay_debts {
    return Intl.message("Você confirma o pagamento dessas despesas?", name: 'confirm_pay_debts');
  }

  String get paid_successfully {
    return Intl.message("Despesas pagas com sucesso!", name: 'paid_successfully');
  }

  String get could_not_pay_registers {
    return Intl.message("Não foi possível pagar as despesas!", name: 'could_not_pay_registers');
  }

  String get expenses {
    return Intl.message("Despesas", name: 'expenses');
  }

  String get nothing_to_pay {
    return Intl.message("Você deve selecionar uma despesa para pagar!", name: 'nothing_to_pay');
  }

  String get nothing_to_reopen {
    return Intl.message("Nenhuma despesa para reabrir!", name: 'nothing_to_reopen');
  }

  String get confirm_reopen_debts {
    return Intl.message("Você confirma a reabertura dessas despesas?", name: 'confirm_reopen_debts');
  }

  String get reopen_successfully {
    return Intl.message("Despesas reabertas com sucesso!", name: 'reopen_successfully');
  }

  String get nothing_to_delete {
    return Intl.message("Você deve selecionar uma despesa para excluir!", name: 'nothing_to_delete');
  }

  String get confirm_delete_debts {
    return Intl.message("Você confirma a exclusão dessas despesas?", name: 'confirm_delete_debts');
  }

  String get delete_successfully {
    return Intl.message("Despesas excluídas com sucesso!", name: 'delete_successfully');
  }

  String get debt_list {
    return Intl.message("Despesas", name: 'debt_list');
  }

  String get expenses_paid {
    return Intl.message("Despesas Pagas", name: 'expenses_paid');
  }

  String get pending_expenses {
    return Intl.message("Pendente", name: 'pending_expenses');
  }

  String get pay_all {
    return Intl.message("Pagar Tudo", name: 'pay_all');
  }

  String get no_open_expense_to_pay {
    return Intl.message("Sem despesas abertas para pagar", name: 'no_open_expense_to_pay');
  }

  String get confirm_delete_debt {
    return Intl.message("Você confirma a exclusão desta despesa?", name: 'confirm_delete_debt');
  }

  String get consult_by_month {
    return Intl.message("Por Mês", name: 'consult_by_month');
  }

  String get consult_by_year {
    return Intl.message("Por Ano", name: 'consult_by_year');
  }

  String get consult_by_paid {
    return Intl.message("Por Pagas", name: 'consult_by_paid');
  }

  String get consult_by_pending {
    return Intl.message("Por Pendentes", name: 'consult_by_pending');
  }

  String get consult_by_payment {
    return Intl.message("Por Local de Pagamento", name: 'consult_by_payment');
  }

  String get change_password {
    return Intl.message("Alterar Senha", name: 'change_password');
  }

  String get logout {
    return Intl.message("Sair", name: 'logout');
  }

  String get current_password {
    return Intl.message("Senha Atual", name: 'current_password');
  }

  String get new_password {
    return Intl.message("Nova Senha", name: 'new_password');
  }

  String get password_successfully_changed {
    return Intl.message("Senha atualizada com sucesso!", name: 'password_successfully_changed');
  }

  String get not_update_password_custom_login {
    return Intl.message("Seu tipo de login não permite que você atualize sua senha!", name: 'not_update_password_custom_login');
  }

  String get direct_debt {
    return Intl.message("Débito Direto", name: 'direct_debt');
  }

  String get press_again_to_exit {
    return Intl.message("Pressione voltar novamente para sair", name: 'press_again_to_exit');
  }

  String get do_not_have_expenses {
    return Intl.message("Você não tem despesas!", name: 'do_not_have_expenses');
  }

  String get error_load_summary {
    return Intl.message("Erro ao carregar o resumo de despesas!", name: 'error_load_summary');
  }

  String get report_by_month {
    return Intl.message("Consulta: Por Mês", name: 'report_by_month');
  }

  String get search {
    return Intl.message("Consultar", name: 'search');
  }

  String get month_year {
    return Intl.message("Mês/Ano", name: 'month_year');
  }

  String get increase_over_last_month {
    return Intl.message("Aumento ref. mês anterior: ", name: 'increase_over_last_month');
  }

  String get decrease_over_last_month {
    return Intl.message("Redução ref. mês anterior: ", name: 'decrease_over_last_month');
  }

  String get increase_percentage {
    return Intl.message("% de aumento: ", name: 'increase_percentage');
  }

  String get decrease_percentage {
    return Intl.message("% de redução: ", name: 'decrease_percentage');
  }

  String get report_by_year {
    return Intl.message("Consulta: Por Ano", name: 'report_by_year');
  }

  String get year {
    return Intl.message("Ano", name: 'year');
  }

  String get invalid_year_format {
    return Intl.message("O formato deve ser AAAA", name: 'invalid_year_format');
  }

  String get no_expenses {
    return Intl.message("Sem Despesas", name: 'no_expenses');
  }

  String get report_by_status {
    return Intl.message("Consulta: Por Status", name: 'report_by_status');
  }

  String get consult_by_status {
    return Intl.message("Por Status", name: 'consult_by_status');
  }

  String get paid {
    return Intl.message("Pagas", name: 'paid');
  }

  String get report_by_local_to_pay {
    return Intl.message("Consulta: Por Local de Pagamento", name: 'report_by_local_to_pay');
  }

  String get show_chart {
    return Intl.message("Mostrar gráfico", name: 'show_chart');
  }

  String get show_list {
    return Intl.message("Mostrar lista", name: 'show_list');
  }

  String get waiting {
    return Intl.message("Aguarde...", name: 'waiting');
  }

  String get all {
    return Intl.message("Todos", name: 'all');
  }

  String get confirm_apply_changes_recurring_expenses {
    return Intl.message("Deseja atualizar todas as despesas recorrentes?", name: 'confirm_apply_changes_recurring_expenses');
  }

  String get only_this {
    return Intl.message("Somente nesta", name: 'only_this');
  }

  String get confirm_remove_recurring_expenses {
    return Intl.message("Todas as despesas recorrentes serão removidas. Continuar?", name: 'confirm_remove_recurring_expenses');
  }

  String get monthly_income {
    return Intl.message("Renda Mensal", name: 'monthly_income');
  }

  String get monthly_income_exist {
    return Intl.message("Já existe um lançamento para este mês!", name: 'monthly_income_exist');
  }

  String get consult_income_x_expenses {
    return Intl.message("Receitas x Despesas", name: 'consult_income_x_expenses');
  }

  String get monthly_income_report {
    return Intl.message("Renda Mensal: ", name: 'monthly_income_report');
  }

  String get total_expesnses {
    return Intl.message("Despesas Totais: ", name: 'total_expesnses');
  }

  String get balance {
    return Intl.message("Saldo: ", name: 'balance');
  }

  String get report_by_income_vs_expenses {
    return Intl.message("Consulta: Receitas x Despesas", name: 'report_by_income_vs_expenses');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("pt", "BR"),
			Locale("en", "US"),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

// ignore_for_file: unnecessary_brace_in_string_interps
