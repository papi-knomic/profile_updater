import 'package:http/http.dart' as http;
import 'package:uploader_app/model/profile_model.dart';

class ProfileRepo {
  void updateProfile(ProfileModel profileModel) async {
    String token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Fmcm9jZW50cmFsLnVrIiwiaWF0IjoxNjg4MTI4MjgyLCJuYmYiOjE2ODgxMjgyODIsImV4cCI6MTY5MDcyMDI4MiwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMTEifX19.esUeSl8u6RFgvbQCS6wNyaAwlnoxNmeCgzzKun5pGi4';

    String filePath = profileModel.image.path;
    String fileName = filePath.split('/').last;

    Uri url =
        Uri.parse('https://afrocentral.uk/wp-json/mobile-app/auth/profile');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    request.fields['firstname'] = profileModel.firstname;
    request.fields['lastname'] = profileModel.lastname;
    request.fields['address'] = profileModel.address;
    request.fields['phone'] = profileModel.phone;
    request.fields['nationality'] = profileModel.nationality;

    var file = await http.MultipartFile.fromPath('image', filePath,
        filename: fileName);
    request.files.add(file);

    print(request.headers);

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    print(response.statusCode);
    print(responseString);
  }
}
