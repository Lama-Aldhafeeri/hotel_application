import 'package:hotel_application/models/hotel.dart';
import 'package:hotel_application/models/reservation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotel_application/models/review.dart';

class SupabaseViewServices {
  static final supabase = Supabase.instance.client;

  Future<List<HotelModel>> getHotelsInfo() async {
    final rawHotels = await supabase.from('hotel').select(
        'hotel_id, hotel_name, hotel_city, hotel_description, room_price, num_rooms, hotel_image, facilities');
    List<HotelModel> hotels = [];
    for (var element in rawHotels) {
      hotels.add(HotelModel.fromJson(element));
    }
    return hotels;
  }

  Future<List<Review>> getReviewsByHotelId(String hotelId) async {
    final rawReviews = await supabase
        .from('review')
        .select('review_id, commit, rating')
        .eq(hotelId, 'hotel_id');
    List<Review> reviews = [];
    for (var element in rawReviews) {
      reviews.add(Review.fromJson(element));
    }
    return reviews;
  }

  Future<List<Reservation>> getReservationByUserId(String userId) async {
    final rawReservation = await supabase
        .from('reservation')
        .select('reservation_id, nights_booked, price, date')
        .eq('user_id', userId);
    List<Reservation> reservation = [];
    for (var element in rawReservation) {
      reservation.add(Reservation.fromJson(element));
    }
    return reservation;
  }

  Future<List<HotelModel>> getHotelInfoforReservation(String userId) async {
    List<HotelModel> hotels = [];
    final hotelIdList = await supabase
        .from('reservation')
        .select('hotel_id')
        .eq('user_id', userId);
    print(hotelIdList.runtimeType);
    print("***** $hotelIdList");

    if (hotelIdList.isEmpty) {
      print("&&");
      return hotels;
    } else {
      for (final element in hotelIdList) {
        print("&&");
        final rawHotels = await supabase
            .from('hotel')
            .select(
                'hotel_id, hotel_name, hotel_city, room_price, num_rooms, hotel_image')
            .eq('hotel_id', element["hotel_id"]);

        print("*********** $rawHotels");

        hotels.add(HotelModel.fromJson(rawHotels[0]));
      }
    }
    print("### $hotels");
    return hotels;
  }

  Future updateReservation(Reservation reservation) async {
    final supabase = Supabase.instance.client;
    await supabase.from('reservation').update({
      'nights_booked': reservation.nightsBooked,
      'date': reservation.date,
      'price': reservation.price
    }).eq('reservation_id', reservation.reservationId ?? '');
  }

  Future insertReservation(Reservation reservation) async {
    final supabase = Supabase.instance.client;
    await supabase.from('reservation').insert(reservation.toJson());
  }

  Future deleteReservation(String reservationId) async {
    final supabase = Supabase.instance.client;
    await supabase
        .from('reservation')
        .delete()
        .eq('reservation_id', reservationId);
  }
}
