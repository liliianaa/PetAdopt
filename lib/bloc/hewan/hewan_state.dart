part of 'hewan_bloc.dart';

abstract class HewanState {}

class HewanInitial extends HewanState {}

class HewanLoading extends HewanState {}

final class HewanSuccess extends HewanState {
  final List<Datum> hewandata;

  HewanSuccess({required this.hewandata});
}

final class HewanPemohonSuccess extends HewanState {
  final Data pemohondata;

  HewanPemohonSuccess({required this.pemohondata});
}

final class updateStatusPemohonSuccess extends HewanState {
  final Acclistpemohonmodel statuspemohon;

  updateStatusPemohonSuccess({required this.statuspemohon});
}

final class HistoryPermohonanSucces extends HewanState {
  final List<Listhistorymodel> historypermohonan;

  HistoryPermohonanSucces({required this.historypermohonan});
}

final class HewanError extends HewanState {
  final String message;

  HewanError({required this.message});
}
