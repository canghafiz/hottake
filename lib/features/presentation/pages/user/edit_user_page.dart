import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    Key? key,
    required this.user,
    required this.userId,
    required this.userAuth,
  }) : super(key: key);
  final String userId;
  final UserEntity user;
  final User userAuth;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final formKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final bio = TextEditingController();
  final socialMedia = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Update State
    dI<CreateAccountCubitEvent>()
        .read(context)
        .updateGender(widget.user.gender);
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    bio.dispose();
    socialMedia.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        endDrawer: drawer(
          theme: theme,
          context: context,
          userId: widget.userId,
          user: widget.userAuth,
        ),
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: fontStyle(size: 15, theme: theme),
          ),
          iconTheme: IconThemeData(color: convertTheme(theme.secondary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Photo
                    Center(
                      child: EditUserPhotoProfileWidget(
                        userId: widget.userId,
                        theme: theme,
                      ),
                    ),
                    // Username
                    EditUserTextfieldWidget(
                      controller: username..text = widget.user.username,
                      label: "Username",
                      theme: theme,
                      prefix: Text(
                        "@ ",
                        style: fontStyle(
                          size: 15,
                          theme: theme,
                        ),
                      ),
                      enable: false,
                      maxLength: null,
                    ),
                    const SizedBox(height: 24),
                    // Email
                    EditUserTextfieldWidget(
                      controller: email..text = widget.user.email,
                      label: "Email",
                      theme: theme,
                      prefix: null,
                      enable: false,
                      maxLength: null,
                    ),
                    const SizedBox(height: 24),
                    // Bio
                    EditUserTextfieldWidget(
                      controller: bio..text = widget.user.bio ?? "",
                      label: "Bio",
                      theme: theme,
                      prefix: null,
                      enable: true,
                      maxLength: 500,
                    ),
                    const SizedBox(height: 24),
                    // Social Media
                    Form(
                      key: formKey,
                      child: EditUserTextfieldWidget(
                        controller: socialMedia
                          ..text = widget.user.socialMedia ?? "",
                        label: "Social Media",
                        theme: theme,
                        prefix: null,
                        enable: true,
                        maxLength: null,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            bool validUrl = Uri.parse(value).isAbsolute;
                            if (!validUrl) {
                              return "Url is not valid!";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Gender Input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "Gender Selection",
                          style: fontStyle(
                            size: 11,
                            theme: theme,
                            weight: FontWeight.w300,
                          ),
                        ),
                        // Input
                        GenderInput(theme: theme),
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Btn Save
                    BlocSelector<CreateAccountCubit, CreateAccountState,
                        double>(
                      selector: (state) {
                        return state.genderValue;
                      },
                      builder: (context, gender) {
                        return ElevatedButtonText(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              dI<UserFirestore>().updateData(
                                email: widget.user.email,
                                userId: widget.userId,
                                username: username.text,
                                bio: (bio.text.isEmpty) ? null : bio.text,
                                socialMedia: (socialMedia.text.isEmpty)
                                    ? null
                                    : socialMedia.text,
                                gender: gender,
                                theme: theme,
                                context: context,
                              );
                            }
                          },
                          themeEntity: theme,
                          text: "Save",
                          btnColor: convertTheme(theme.secondary),
                          textColor: convertTheme(theme.primary),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            PhotoUploadBar(theme: theme),
          ],
        ),
      ),
    );
  }
}

// Photo
class EditUserPhotoProfileWidget extends StatelessWidget {
  const EditUserPhotoProfileWidget({
    Key? key,
    required this.userId,
    required this.theme,
  }) : super(key: key);
  final String userId;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    Widget photo(String? url) {
      return SizedBox(
        height: 128,
        width: 128,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (url != null) {
                  // Navigate
                  toImageDetailPage(context: context, url: url);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: convertTheme(
                      theme.secondary,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    PhotoProfileWidget(url: url, size: 128, theme: theme),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: convertTheme(
                            theme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocSelector<ImageCubit, ImageState, bool>(
              selector: (state) {
                return state.onUpload;
              },
              builder: (context, onUpload) {
                return GestureDetector(
                  onTap: () {
                    if (onUpload) {
                      // Show Dialog
                      showDialog(
                        context: context,
                        builder: (context) => textDialog(
                          text: "You must wait",
                          size: 13,
                          color: Colors.red,
                          align: TextAlign.center,
                        ),
                      );

                      return;
                    }
                    // Show Modal Bottom
                    showModalBottom(
                      theme: theme,
                      context: context,
                      content: photoProfileBottomSheetWidget(
                        context: context,
                        url: url,
                        theme: theme,
                        userId: userId,
                      ),
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: convertTheme(theme.primary),
                        border: Border.all(
                          width: 3,
                          color: convertTheme(
                            theme.secondary,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: convertTheme(theme.secondary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: dI<UserFirestore>().getRealTimeUser(userId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return photo(null);
        } else {
          if (snapshot.data!.data() != null) {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            return photo(data['photo']);
          }
        }
        return photo(null);
      },
    );
  }
}

// Textfield
class EditUserTextfieldWidget extends StatelessWidget {
  const EditUserTextfieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.theme,
    required this.prefix,
    required this.enable,
    required this.maxLength,
    this.validator,
  }) : super(key: key);
  final TextEditingController controller;
  final String label;
  final ThemeEntity theme;
  final Widget? prefix;
  final bool enable;
  final int? maxLength;
  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: convertTheme(theme.third),
      ),
    );
    final activeBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: convertTheme(theme.third),
        width: 3,
      ),
    );

    return TextFormField(
      enabled: enable,
      controller: controller,
      validator: (validator == null) ? null : (value) => validator!(value),
      style: fontStyle(
        size: 13,
        theme: theme,
        weight: FontWeight.bold,
      ),
      cursorColor: convertTheme(theme.secondary),
      maxLength: maxLength,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(4),
        border: border,
        errorBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: activeBorder,
        focusedErrorBorder: activeBorder,
        prefix: prefix,
        labelText: label,
        labelStyle: fontStyle(size: 15, theme: theme, weight: FontWeight.w300),
        errorStyle: fontStyle(
          size: 13,
          theme: theme,
        ),
        counterStyle: fontStyle(
          size: 11,
          theme: theme,
        ),
      ),
    );
  }
}
