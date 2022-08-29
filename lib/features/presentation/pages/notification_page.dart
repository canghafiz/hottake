import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (context, theme) => Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: dI<NotificationFirestore>().getNotifications(user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: convertTheme(theme.secondary),
                ),
              );
            }
            return (snapshot.data!.docs.isEmpty)
                ? Center(
                    child: Text(
                    "Empty",
                    style: fontStyle(size: 13, theme: theme),
                  ))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "Total notifications: ${snapshot.data!.docs.length}",
                                  style: fontStyle(
                                    size: 13,
                                    theme: theme,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Btn Clear
                              GestureDetector(
                                onTap: () {
                                  dI<DeleteAllNotification>().call(
                                    userId: user.uid,
                                    context: context,
                                  );
                                },
                                child: Text(
                                  "Clear All",
                                  style: fontStyle(size: 13, theme: theme),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Notifications
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // Model
                              final DocumentSnapshot doc =
                                  snapshot.data!.docs[index];
                              final NotificationEntity notification =
                                  NotificationEntity.fromMap(
                                doc.data() as Map<String, dynamic>,
                              );

                              return NotificationCardWidget(
                                notification: notification,
                                userId: user.uid,
                                theme: theme,
                                notificationId: doc.id,
                                userAuth: user,
                              );
                            },
                            separatorBuilder: (_, __) => Container(
                              height: 1,
                              width: double.infinity,
                              color: convertTheme(theme.secondary)
                                  .withOpacity(0.5),
                            ),
                            itemCount: snapshot.data!.docs.length,
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
