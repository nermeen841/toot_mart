import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toot_mart/core/constants/colors.dart';
import 'package:toot_mart/core/utiles/size_config.dart';
import 'package:toot_mart/core/widgets/custom_buttons_widget.dart';
import 'package:toot_mart/core/widgets/custom_text_field.dart';
import 'package:toot_mart/core/widgets/space_widget.dart';
import 'package:toot_mart/translations/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/helper/validation.dart';
import '../../../../core/network/local/cache_helper.dart';
import '../../../../core/router/router.dart';
import '../../../account/account.dart';
import '../../../layout/layout.dart';
import '../../data/business_logic/auth_cubit.dart';
import '../../data/business_logic/auth_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  bool accepted = false;

  FocusNode emailFocusNode = FocusNode();

  FocusNode nameFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  FocusNode phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterUserSuccessState) {
          if (AuthCubit.get(context).user != null) {
            CasheHelper.SaveUser(user: AuthCubit.get(context).user!);
            kUser = AuthCubit.get(context).user;
          }
          MagicRouter.navigateTo(const LayoutScreen(
            index: 0,
          ));
          AuthCubit.get(context).changeUserState(AccountStates.GUEST);
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpace(value: 3),
                Center(
                  child: Text(
                    LocaleKeys.sign_up.tr(),
                    style: headingStyle.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const VerticalSpace(value: 3),
                Text(
                  LocaleKeys.name.tr(),
                  style: headingStyle.copyWith(color: colorGrey),
                ),
                const VerticalSpace(value: 1),
                CustomTextFormField(
                  focusNode: nameFocusNode,
                  controller: nameController,
                  inputType: TextInputType.name,
                  validator: (String? value) {
                    return validateName(value!);
                  },
                  onEditingComplete: () {
                    nameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  },
                ),
                const VerticalSpace(value: 2),
                Text(
                  LocaleKeys.email.tr(),
                  style: headingStyle.copyWith(color: colorGrey),
                ),
                const VerticalSpace(value: 1),
                CustomTextFormField(
                  focusNode: emailFocusNode,
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  validator: (String? value) {
                    return validateEmail(emailController.text);
                  },
                  onEditingComplete: () {
                    emailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  },
                ),
                const VerticalSpace(value: 2),
                Text(
                  LocaleKeys.password.tr(),
                  style: headingStyle.copyWith(color: colorGrey),
                ),
                const VerticalSpace(value: 1),
                CustomTextFormField(
                  focusNode: passwordFocusNode,
                  isPassword: true,
                  controller: passwordController,
                  validator: (String? value) {
                    return validatePassword(value!);
                  },
                  onEditingComplete: () {
                    passwordFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(phoneFocusNode);
                  },
                ),
                const VerticalSpace(value: 2),
                Text(
                  LocaleKeys.phone_number.tr(),
                  style: headingStyle.copyWith(color: colorGrey),
                ),
                const VerticalSpace(value: 1),
                CustomTextFormField(
                  focusNode: phoneFocusNode,
                  controller: phoneController,
                  inputType: TextInputType.phone,
                  validator: (String? value) {
                    return validateMobile(value!);
                  },
                  onEditingComplete: () {
                    phoneFocusNode.unfocus();
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                        height: SizeConfig.defaultSize! * 5.5,
                        width: SizeConfig.defaultSize! * 5.5,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor: Colors.grey // Your color
                              ),
                          child: Checkbox(
                              activeColor: kMainColor,
                              value: accepted,
                              onChanged: (value) {
                                setState(() {});
                                accepted = !accepted;
                              }),
                        )),
                    Text(LocaleKeys.accept_all_conditions_and_terms.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.defaultSize! * 1.5,
                        )),
                  ],
                ),
                const VerticalSpace(value: 2),
                if (state is! RegisterUserLoadingState)
                  CustomGeneralButton(
                      isActive: accepted,
                      text: LocaleKeys.REGISTER.tr(),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.RegisterUser(
                              nameController.text,
                              phoneController.text,
                              emailController.text,
                              passwordController.text);
                        }
                      }),
                if (state is RegisterUserLoadingState)
                  Center(
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  ),
                const VerticalSpace(value: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: colorGrey,
                      height: 1,
                    )),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or'),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: colorGrey,
                      height: 1,
                    )),
                  ],
                ),
                const VerticalSpace(value: 2),
                CustomStrockButton(
                    text: LocaleKeys.login.tr(),
                    onTap: () {
                      AuthCubit.get(context)
                          .changeUserState(AccountStates.LOGIN);
                    }),
                const VerticalSpace(value: 5),
                Center(
                  child: SizedBox(
                      height: SizeConfig.defaultSize! * 2,
                      child: Image.asset(
                        'asset/images/social.png',
                        color: kMainColor,
                      )),
                ),
                const VerticalSpace(value: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
