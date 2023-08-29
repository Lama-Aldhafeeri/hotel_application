import 'package:flutter/material.dart';
import 'package:hotel_application/db_services/services.dart';
import 'package:hotel_application/models/hotel.dart';

import '../db_services/quaries.dart';
import 'my_bookings_list_screen.dart';

class ReserScreen extends StatefulWidget {
  const ReserScreen({super.key});

  @override
  State<ReserScreen> createState() => _ReserScreenState();
}

final currentUserId = SupabaseClass.supabase.auth.currentSession?.user.id;
List<HotelModel> hotelInfoforReservationList = [];

Future<void> getAllInfo() async {
  hotelInfoforReservationList =
      await SupabaseViewServices().getHotelInfoforReservation(currentUserId!);
}

class _ReserScreenState extends State<ReserScreen> {
  @override
  void initState() {
    getAllInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: SupabaseViewServices().getReservationByUserId(currentUserId!),
      builder: (context, snapshot) {
        final list = snapshot.data;

        return MyBookingScreen(
            reserveList: list ?? [],
            hotelWReserve: hotelInfoforReservationList);
      },
    ));
  }
}
