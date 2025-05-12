import 'package:image_picker/image_picker.dart';
import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/auth/presentation/auth.dart';
import 'package:lombard/src/feature/profile/data/profile_remote_ds.dart';
import 'package:lombard/src/feature/profile/models/response/about_us_dto.dart';
import 'package:lombard/src/feature/profile/models/response/document_dto.dart';
import 'package:lombard/src/feature/profile/models/response/faq_dto.dart';
import 'package:lombard/src/feature/profile/models/response/social_media_dto.dart';
import 'package:lombard/src/feature/profile/models/response/working_hour_dto.dart';

abstract interface class IProfileRepository {
  Future<UserDTO> profileData();

  Future<List<FaqDTO>> faqList();

  Future<List<SocialMediaDTO>> socialMediaList();

  Future<List<WorkingHourDTO>> workingHourList();

  Future<List<AboutUsDTO>> aboutUsList();

  Future<List<DocumentDTO>> documents();

  Future<BasicResponse> deleteAccount();

  Future<BasicResponse> logout();

  Future<BasicResponse> editAccount({
    required UserPayload userPayload,
    XFile? avatar,
  });
}

class ProfileRepositoryImpl implements IProfileRepository {
  const ProfileRepositoryImpl({
    required IProfileRemoteDS remoteDS,
  }) : _remoteDS = remoteDS;
  final IProfileRemoteDS _remoteDS;

  @override
  Future<UserDTO> profileData() async {
    try {
      return await _remoteDS.profileData();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BasicResponse> deleteAccount() async {
    try {
      return await _remoteDS.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BasicResponse> logout() async {
    try {
      return await _remoteDS.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BasicResponse> editAccount({
    required UserPayload userPayload,
    XFile? avatar,
  }) async {
    try {
      return await _remoteDS.editAccount(userPayload: userPayload, avatar: avatar);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FaqDTO>> faqList() async {
    try {
      return await _remoteDS.faqList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SocialMediaDTO>> socialMediaList() async {
    try {
      return await _remoteDS.socialMediaList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AboutUsDTO>> aboutUsList() async {
    try {
      return await _remoteDS.aboutUsList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WorkingHourDTO>> workingHourList() async {
    try {
      return await _remoteDS.workingHourList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DocumentDTO>> documents() async {
    try {
      return await _remoteDS.documents();
    } catch (e) {
      rethrow;
    }
  }
}
