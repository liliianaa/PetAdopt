// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/model/List_pemohon_model.dart';
import 'package:petadopt/model/acc_pemohon_model.dart';
import 'package:petadopt/model/hewan_respon_model.dart';
import 'package:petadopt/model/pemohonModel.dart';

import 'package:petadopt/providers/hewan_provider.dart';

part 'hewan_event.dart';
part 'hewan_state.dart';

class HewanBloc extends Bloc<HewanEvent, HewanState> {
  final Hewanrepositories hewanrepositories;
  HewanBloc(
    this.hewanrepositories,
  ) : super(HewanInitial()) {
    on<AddHewanEvent>((event, emit) async {
      print("Bloc: emit HewanLoading");
      emit(HewanLoading());

      final result = await hewanrepositories.addHewan(
        imageFile: event.imageFile,
        nama: event.nama,
        jenis_kelamin: event.jenisKelamin,
        warna: event.warna,
        jenis_hewan: event.jenisHewan,
        umur: event.umur,
        status: event.status,
        lokasi: event.lokasi,
        deskripsi: event.deskripsi,
      );

      if (result.isRight()) {
        final datum = result.getOrElse(() => throw Exception('Data kosong'));
        emit(HewanSuccess(hewandata: [datum])); // jadikan list berisi 1 item
      } else {
        final failureMessage = result.swap().getOrElse(() => 'Unknown error');
        emit(HewanError(message: failureMessage));
      }
    });

    on<GetHewanEvent>((event, emit) async {
      emit(HewanLoading());

      try {
        final Hewan? hewanData = await hewanrepositories.getHewan();

        if (hewanData != null &&
            hewanData.data != null &&
            hewanData.data!.isNotEmpty) {
          emit(HewanSuccess(hewandata: hewanData.data!));
        } else {
          emit(HewanError(message: 'Data hewan tidak ditemukan.'));
        }
      } catch (e) {
        emit(HewanError(message: 'Terjadi kesalahan: $e'));
      }
    });

    on<GetHewanByIdEvent>((event, emit) async {
      emit(HewanLoading());

      final result = await hewanrepositories.getHewanById(event.id);

      result.fold(
        (failureMessage) {
          emit(HewanError(message: failureMessage));
        },
        (datum) {
          emit(HewanSuccess(hewandata: [datum]));
        },
      );
    });

    on<GetHewanByJenisEvent>((event, emit) async {
      emit(HewanLoading());
      final result = await hewanrepositories.getHewanByJenis(event.jenis);

      result.fold(
        (errorMessage) => emit(HewanError(message: errorMessage)),
        (data) => emit(HewanSuccess(hewandata: data)),
      );
    });

    on<UpdateHewanEvent>((event, emit) async {
      emit(HewanLoading());
      final response = await hewanrepositories.updateHewan(
        id: event.id, // Pastikan ini ada di parameter method updateHewan
        nama: event.nama,
        jenis_kelamin: event.jenis_kelamin,
        warna: event.warna,
        jenis_hewan: event.jenis_hewan,
        umur: event.umur,
        status: event.status,
        deskripsi: event.deskripsi,
        imageFile: event.imageFile, // Tambahkan parameter gambar
      );

      if (response['success'] && response['data'] != null) {
        emit(HewanSuccess(hewandata: response['data']));
      } else {
        emit(HewanError(
            message: response['message'] ?? 'Gagal mengupdate hewan'));
      }
    });
    on<GetMyPets>((event, emit) async {
      emit(HewanLoading());
      try {
        final pets = await hewanrepositories.getmypets();
        emit(HewanSuccess(hewandata: pets));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<GetPemohonHewanbyID>((event, emit) async {
      emit(HewanLoading());
      try {
        final pemohon = await hewanrepositories.getPemohonHewanbyID(event.id);
        emit(HewanSuccess(hewandata: pemohon));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<getDetailPemohon>((event, emit) async {
      emit(HewanLoading());
      try {
        final permohon = await hewanrepositories.getDetailDataPemohon(
            event.id, event.userId);
        emit(HewanPemohonSuccess(pemohondata: permohon));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<updatestatusPemohon>((event, emit) async {
      emit(HewanLoading());
      try {
        final status = await hewanrepositories.Updatestatuspermohonan(
            event.pemohonId, event.accpemohon);
        emit(updateStatusPemohonSuccess(statuspemohon: status));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<getHistoryPermohonan>((event, emit) async {
      emit(HewanLoading());
      try {
        final history = await hewanrepositories.getHistoryPermohonan();
        emit(HistoryPermohonanSucces(historypermohonan: history));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<getDetailhistorypemohon>((event, emit) async {
      emit(HewanLoading());
      try {
        final detailhistory =
            await hewanrepositories.getDetailHistoryPemohon(event.pemohonID);
        emit(HewanPemohonSuccess(pemohondata: detailhistory));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<deletepermohonan>((event, emit) async {
      emit(HewanLoading());
      try {
        final deletePermohonan =
            await hewanrepositories.DeletePermohonan(event.permohonanID);
        emit(HewanPemohonSuccess(pemohondata: deletePermohonan));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
    on<EditDataPemohon>((event, emit) async {
      emit(HewanLoading());
      try {
        final datapemohon = await hewanrepositories.UpdateDataPemohon(
            event.permohonanID, event.datapermohonan);
        emit(HewanPemohonSuccess(pemohondata: datapemohon));
      } catch (e) {
        emit(HewanError(message: e.toString()));
      }
    });
  }
}
