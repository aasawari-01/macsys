import 'dart:convert';

import 'package:get/get.dart';
import 'package:macsys/services/remote_services.dart';

import 'dropdown_siteaddress_model.dart';

// class SiteAddressController extends GetxController {
//   var siteAddresses = <Map<String, dynamic>>[].obs;
//   var isLoading = true.obs;
//   var selectedSiteAddress = Rx<Map<String, dynamic>?>(null);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchSiteAddresses();
//   }

//   Future<void> fetchSiteAddresses() async {
//     const endpoint = "api/v1/site-address";

//     try {
//       isLoading(true);

//       final response = await RemoteServices.fetchGetData(endpoint);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         siteAddresses.value =
//             List<Map<String, dynamic>>.from(data["site_addresses"]);

//         if (siteAddresses.isNotEmpty) {
//           selectedSiteAddress.value = siteAddresses[0];
//         }
//       } else {
//         print(
//             "Failed to fetch site addresses. Status Code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching site addresses: $e");
//     } finally {
//       isLoading(false);
//     }

//     update();
//   }
// }

class SiteAddressController extends GetxController {
  var siteAddresses = <SiteAddresses>[].obs; // Now using the model list
  var isLoading = true.obs;
  var selectedSiteAddress = Rx<SiteAddresses?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSiteAddresses();
  }

  Future<void> fetchSiteAddresses() async {
    const endpoint = "api/v1/site-address";

    try {
      isLoading(true);

      final response = await RemoteServices.fetchGetData(endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Deserialize the JSON response into the model object
        SiteAddressResponse siteAddressResponse =
            SiteAddressResponse.fromJson(data);

        // Now siteAddresses is a list of SiteAddresses, and you can directly access it
        siteAddresses.value = siteAddressResponse.siteAddresses;

        // Optionally, select the first address if available
        if (siteAddresses.isNotEmpty) {
          selectedSiteAddress.value = siteAddresses[0];
        }
      } else {
        print(
            "Failed to fetch site addresses. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching site addresses: $e");
    } finally {
      isLoading(false);
    }

    update();
  }
}
