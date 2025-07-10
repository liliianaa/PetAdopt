import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ShelterEvent extends Equatable {
  const ShelterEvent();

  @override
  List<Object?> get props => [];
}

class UploadShelterRequestEvent extends ShelterEvent {
  final File file;

  const UploadShelterRequestEvent(this.file);

  @override
  List<Object?> get props => [file];
}
