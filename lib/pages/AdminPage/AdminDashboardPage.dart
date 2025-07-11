import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt/bloc/admin/admin_bloc.dart';
import 'package:petadopt/config/ColorConfig.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:petadopt/pages/AdminPage/NotikasiAdminPage.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger both events
    context.read<AdminBloc>()
      ..add(getjumlahuser())
      ..add(getjumlahhewan());

    return Scaffold(
      backgroundColor: ColorConfig.mainbabyblue1,
      appBar: AppBar(
        // centerTitle: Title(color: color, child: child),
        backgroundColor: ColorConfig.mainbabyblue1,
        elevation: 0,
        leading: Row(
          children: [
            const SizedBox(width: 12),
            Image.asset('assets/logo.png', height: 40),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotifikasiPage()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading || state is AdminInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is dashboardAdminsuccess) {
            final jumlahUser = state.jumlahUser?.data;
            final jumlahHewan = state.jumlahHewan?.data;

            if (jumlahUser == null || jumlahHewan == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Hewan',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildStatChartWithTotal(
                    total: jumlahHewan.totalHewan ?? 0,
                    labels: const ['Kucing', 'Anjing'],
                    values: [
                      (jumlahHewan.kucing ?? 0).toDouble(),
                      (jumlahHewan.anjing ?? 0).toDouble(),
                    ],
                    colors: [ColorConfig.mainwhite, ColorConfig.mainwhite],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Jumlah User",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildStatChartWithTotal(
                    total: jumlahUser.totalUsers ?? 0,
                    labels: const ['User', 'Shelter', 'Admin'],
                    values: [
                      (jumlahUser.user ?? 0).toDouble(),
                      (jumlahUser.shelter ?? 0).toDouble(),
                      (jumlahUser.admin ?? 0).toDouble(),
                    ],
                    colors: [
                      ColorConfig.mainwhite,
                      ColorConfig.mainwhite,
                      ColorConfig.mainwhite,
                    ],
                  ),
                ],
              ),
            );
          } else if (state is Adminerror) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text("Tidak ada data"));
          }
        },
      ),
    );
  }

  Widget _buildStatChartWithTotal({
    required int total,
    required List<String> labels,
    required List<double> values,
    required List<Color> colors,
  }) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConfig.mainblue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$total',
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: ColorConfig.mainwhite),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: values.asMap().entries.map((entry) {
                  int index = entry.key;
                  double value = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        width: 20,
                        color: colors[index],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }).toList(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        if (value.toInt() < labels.length) {
                          return Text(
                            labels[value.toInt()],
                            style:
                                const TextStyle(color: ColorConfig.mainwhite),
                          );
                        }
                        return const Text(
                          '',
                          style: TextStyle(color: ColorConfig.mainwhite),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
