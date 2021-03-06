
// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, avoid_print
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helper/functions/show_toast.dart';
import '../../../../core/constants/constants.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../account/account.dart';
import '../model/user_model.dart';
import '../repositories/auth_repository_imp.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  UserModel? user;

  // ignore: non_constant_identifier_names
  UserModel? LoginUser(String Username, String Password) {
    emit(LoginUserLoadingstate());
    AuthRepositoryImpl()
        .loginWithEmailAndPassword(Username: Username, Password: Password)
        .then((value) {
      if (value != []) {
        user = value.getOrElse(() {
          return UserModel.fromJson({});
        });
        print('skdhfbalksdfaksdf'+userModelToJson(user!));
        if (user!.body!.accessToken == null || user!.body!.accessToken == '') {
          showToast(msg: LocaleKeys.error_in_sign_in.tr(), state: ToastStates.ERROR);
          emit(LoginUserErrorstate());
        } else {
          showToast(
              msg: 'LocaleKeys.signed_in_successfully.tr()',
              state: ToastStates.SUCCESS);
          emit(LoginUserLoaded());
          print(user!.body!.accessToken);
        }
      }
    });
    return null;
  }

  UserModel? RegisterUser(String name, String phone, String email, String password) {
    emit(RegisterUserLoadingState());
    AuthRepositoryImpl()
        .registerWithEmailAndPassword(
            name: name, phone: phone, email: email, password: password)
        .then((value) {
      if (value != null) {
        user = value.getOrElse(() => UserModel.fromJson({}));
        if(user!.body!.accessToken !=''){
          showToast(
              msg: LocaleKeys.signed_in_successfully.tr(),
              state: ToastStates.SUCCESS);
          emit(RegisterUserSuccessState());
        }else{
          if(user!.message.toString() == 'The email field must be unique.'){
            showToast(
                msg:'?????? ???????????? ???????????????????? ???????????? ???? ??????',
                state: ToastStates.ERROR);
          }else if(user!.message.toString() == 'The mobile has already been taken.'){
            showToast(
                msg:'?????? ???????????? ???????????? ???? ??????',
                state: ToastStates.ERROR);
          }else{
            showToast(
                msg:'???????????? ?????????????????? ?? ?????? ???????????? ???? ?????????????????? ???? ??????',
                state: ToastStates.ERROR);
          }
          emit(RegisterUserErrorState());
        }

        print(value);
      }else{
        showToast(
            msg:  ' ?????? ???? ?????????? ????????????',
            state: ToastStates.ERROR);
        emit(RegisterUserErrorState());
      }
    });
    return null;
  }

  UserModel? editProfile({required String name,required String phone,required String email}) {
    emit(EditProfileLoadingState());
    AuthRepositoryImpl()
        .editProfile(
            name: name, phone: phone, email: email)
        .then((value) {
      if (value != []) {
        user = value.getOrElse(() => UserModel.fromJson({}));
        showToast(
            msg: '???? ?????????? ???????????????? ??????????',
            state: ToastStates.SUCCESS);
        kUser = user;
        emit(EditProfileSuccessState());
      }
    });
    return null;
  }
//
//   Future<User>? SignOut() {
//     AuthRepositoryImpl().SignOut().then((value) {
//       if (value != []) {
//         kUser = null;
//         CasheHelper.removeData(key: 'User');
//         showToast(
//             msg: value.getOrElse(() => 'not signed out'),
//             state: ToastStates.SUCCESS);
//         emit(UserSignedOutSuccessfully());
//       }
//     });
//     return null;
//   }
//   Future<User>? changePassword({
//   required String oldPassword,
//   required String newPassword,
//   required String newPasswordConfirmation,
// }) {
//     AuthRepositoryImpl().changePassword(oldPassword, newPassword, newPasswordConfirmation).then((value) {
//       if (value != []) {
//         showToast(
//             msg: value.getOrElse(() => 'not signed out'),
//             state: ToastStates.SUCCESS);
//         emit(PasswordChangedSuccessfully());
//       }
//     });
//     return null;
//   }
  AccountStates? currentUserState;
  changeUserState(AccountStates userState){
    currentUserState = userState;
    emit(ChangeUserState());
  }
//
//

  // FavouritesModel? favouritesModel;
  // List<Product>? getFavouteProducts() {
  //   emit(FavouteProductsLoadingState());
  //   AuthRepositoryImpl().getFavouriteProducts().then((value) {
  //     if (value != []) {
  //       if(favouritesModel !=null) {
  //         favouritesModel!.data = [];
  //       }
  //       favouritesModel =
  //           value.getOrElse(() => FavouritesModel.fromJson({}));
  //       emit(FavouteProductsSuccessState());
  //     }
  //   });
  //   return null;
  // }

  // RefundOrdersModel? refundOrdersModel;
  //
  // List<OrdersModel>? getRefundOrders() {
  //   emit(AllRefundOrdersLoadingState());
  //   AuthRepositoryImpl().getRefundOrders().then((value) {
  //     if (value != []) {
  //
  //       refundOrdersModel = value.getOrElse(() {
  //         emit(AllRefundOrdersErrorState());
  //         return RefundOrdersModel.fromJson({});
  //       });
  //       emit(AllRefundOrdersSuccessState());
  //     }
  //
  //   });
  //   return null;
  // }
}
