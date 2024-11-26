import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppStateEvent extends Equatable {
  const AppStateEvent();

  @override
  List<Object> get props => [];
}

class LoadAppState extends AppStateEvent {}

class UpdateLastOpenedPage extends AppStateEvent {
  final String page;

  const UpdateLastOpenedPage(this.page);

  @override
  List<Object> get props => [page];
}
















class ChangeLanguage extends AppStateEvent {
  final Locale locale;
  final BuildContext context;
 const ChangeLanguage(this.locale, this.context);



@override
List<Object> get props => [locale, context];
}


 class ChangeTheme extends AppStateEvent{
    const ChangeTheme();
  
  @override
  List<Object> get props => [];

 }
